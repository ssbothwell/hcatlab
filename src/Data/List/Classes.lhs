> module Data.List.Classes where

> import Data.Either
> import Data.Unit
> import Data.Function
> import Data.List.Type

> import Typeclasses.Generic
> import Typeclasses.Eq
> import Typeclasses.Ord
> import Typeclasses.Semigroup
> import Typeclasses.Monoid
> import Typeclasses.Functor
> import Typeclasses.Applicative
> import Typeclasses.Monad
> import Typeclasses.Foldable
> import Typeclasses.Traversable

> instance Generic (List a) where
>   type Rep (List a) = Either Unit (Wrap a, Wrap (List a))
>
>   from :: List a -> Rep (List a)
>   from Nil = Left Unit
>   from (Cons x xs) = Right (Wrap x, Wrap xs)
>
>   to :: Rep (List a) -> List a
>   to (Left Unit) = Nil
>   to (Right (Wrap x, Wrap xs)) = Cons x xs

> instance Eq a => Eq (List a) where
>   (==) = eq

> instance Semigroup (List a) where
>   (<>) :: List a -> List a -> List a
>   (<>) xs Nil = xs
>   (<>) Nil ys = ys
>   (<>) (Cons x xs) ys = Cons x (xs <> ys)

> instance Monoid (List a) where
>   mempty :: List a
>   mempty = Nil

> instance Functor List where
>   fmap :: (a -> b) -> List a -> List b
>   fmap f (Cons x xs) = Cons (f x) (f <$> xs)
>   fmap f Nil = Nil

> instance Applicative List where
>   pure :: a -> List a
>   pure a = Cons a Nil
>   (<*>) :: List (a -> b) -> List a -> List b
>   (<*>) (Cons f fs) xs = (f <$> xs) <> (fs <*> xs)
>   (*>) :: List a -> List b -> List b
>   (*>) xs ys = xs >>= \_ -> ys >>= \y -> pure y
>   (<*) :: List a -> List b  -> List a
>   (<*) xs ys = xs >>= \x -> ys >>= \_ -> pure x

> instance Monad List where
>   (>>=) :: List a -> (a -> List b) -> List b
>   (>>=) = flip foldMap
>   (>>) :: List a -> List b -> List b
>   (>>) = (*>)

> instance Foldable List where
>   foldMap :: Monoid m => (a -> m) -> List a -> m
>   foldMap f = foldr (mappend . f) mempty
>   foldr :: (a -> b -> b) -> b -> List a -> b
>   foldr _ b Nil = b
>   foldr f b (Cons x xs) = x `f` foldr f b xs

> instance Traversable List where
>   traverse :: Applicative f => (a -> f b) -> List a -> f (List b)
>   traverse f = foldr (\x ys -> liftA2 Cons (f x) ys) (pure Nil)
>   sequenceA :: Applicative f => List (f a) -> f (List a)
>   sequenceA Nil = pure Nil
>   sequenceA (Cons x xs) = Cons <$> x <*> sequenceA xs

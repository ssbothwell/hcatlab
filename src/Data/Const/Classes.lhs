> module Data.Const.Classes where

> import Data.Const.Type
> import Data.Function

> import Typeclasses.Semigroup
> import Typeclasses.Monoid
> import Typeclasses.Functor
> import Typeclasses.Applicative.Class
> import Typeclasses.Monad
> import Typeclasses.Foldable
> import Typeclasses.Traversable

> import Prelude (undefined)

> instance Semigroup a => Semigroup (Const a b) where
>   (<>) :: Const a b -> Const a b -> Const a b
>   (<>) (Const a) (Const b) = Const $ a <> b

> instance Monoid a => Monoid (Const a b) where
>   mempty :: Const a b
>   mempty = Const mempty
>   mappend :: Const a b -> Const a b -> Const a b
>   mappend = (<>)

> instance Functor (Const c) where
>   fmap :: (a -> b) -> Const c a -> Const c b
>   fmap f (Const a) = Const a

> instance Monoid c => Applicative (Const c) where
>   pure :: a -> Const c a
>   pure a = Const mempty
>   (<*>) :: Const c (a -> b) -> Const c a -> Const c b
>   (<*>) (Const c) (Const c') = Const $ c <> c'

> instance Foldable (Const c) where
>   foldr :: (a -> b -> b) -> b -> Const c a -> b
>   foldr _ z _ = z

> instance Traversable (Const c) where
>   sequenceA :: Applicative f => Const c (f a) -> f (Const c a)
>   sequenceA (Const c) = pure $ Const c
>   traverse :: Applicative f => (a -> f b) -> Const c a -> f (Const c b)
>   traverse _ (Const c) = pure $ Const c

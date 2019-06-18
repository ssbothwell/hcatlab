module Data.Identity where

import Prelude (Show)

import Data.Function

import Typeclasses.Semigroup
import Typeclasses.Monoid
import Typeclasses.Functor
import Typeclasses.Applicative
import Typeclasses.Monad
import Typeclasses.Foldable
import Typeclasses.Traversable

newtype Identity a = Identity { runIdentity :: a }
  deriving Show


-------------------
--- TYPECLASSES ---
-------------------

instance Semigroup a => Semigroup (Identity a) where
  (<>) :: Identity a -> Identity a -> Identity a
  (<>) (Identity a) (Identity b) = Identity $ a <> b

instance Monoid a => Monoid (Identity a) where
  mempty :: Identity a
  mempty = Identity mempty
  mappend :: Identity a -> Identity a -> Identity a
  mappend = (<>)

instance Functor Identity where
  fmap :: (a -> b) -> Identity a -> Identity b
  fmap f (Identity a) = Identity $ f a

instance Applicative Identity where
  pure :: a -> Identity a
  pure = Identity
  (<*>) :: Identity (a -> b) -> Identity a -> Identity b
  (<*>) (Identity f) (Identity a) = Identity $ f a

instance Monad Identity where
  return :: a -> Identity a
  return = pure
  (>>=) :: Identity a -> (a -> Identity b) -> Identity b
  (>>=) (Identity a) f = f a

instance Foldable Identity where
  foldr :: (a -> b -> b) -> b -> Identity a -> b
  foldr f z (Identity a) = f a z

instance Traversable Identity where
  sequenceA :: Applicative f => Identity (f a) -> f (Identity a)
  sequenceA (Identity fa) = fmap Identity fa

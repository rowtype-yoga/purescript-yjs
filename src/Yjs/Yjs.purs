module Yjs.Yjs
  ( ArrayEvent
  , Handler(..)
  , Origin
  , Provider
  , Transaction
  , XmlEvent
  , YArray
  , YDoc
  , YMap
  , YText
  , YXmlFragment
  , YXmlText
  , class Insert
  , class Observable
  , class Push
  , class ToJson
  , deleteAt
  , getArray
  , getYMap
  , insert
  , mapYArray
  , mapYArrayWithIndex
  , mkHandler
  , mkYDoc
  , mkYMap
  , mkYText
  , mkYXmlFragment
  , mkYXmlText
  , observe
  , observeDeep
  , push
  , setYMap
  , toArray
  , toDOM
  , toJSON
  , transact
  , yTextToString
  ) where

import Prelude

import Data.Function.Uncurried (Fn2, mkFn2, runFn2)
import Data.Newtype (class Newtype)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3)
import Foreign (Foreign)
import Web.DOM (DocumentFragment)

foreign import unsafeEq :: forall t. t -> t -> Boolean

newtype Handler event = Handler (EffectFn1 event Unit)

instance Newtype (Handler event) (EffectFn1 event Unit)

mkHandler ∷ ∀ (event ∷ Type). (event → Effect Unit) → Handler event
mkHandler = mkEffectFn1 >>> Handler

class Observable a event | a -> event where
  observe :: a -> Handler event -> Effect (Effect Unit)
  observeDeep :: a -> Handler event -> Effect (Effect Unit)

foreign import unsafeObserveImpl :: forall observable event. EffectFn2 observable (Handler event) (Effect Unit)

foreign import unsafeObserveDeepImpl :: forall observable event. EffectFn2 observable (Handler event) (Effect Unit)

class ToJson elem json | elem -> json where
  toJSON :: elem -> json

foreign import unsafePushImpl :: forall t elem. EffectFn2 t elem Unit

class Push t e where
  push :: t -> e -> Effect Unit

class Insert t e where
  insert :: t -> e -> Int -> Effect Unit

foreign import data Provider :: Type

foreign import data YDoc :: Type

instance Eq YDoc where
  eq = unsafeEq

foreign import mkYDoc :: Effect YDoc

type Transaction = Effect Unit
type Origin = String

foreign import transactImpl :: EffectFn3 YDoc Transaction Origin Unit

transact ∷ YDoc → Effect Unit → Origin → Effect Unit
transact = runEffectFn3 transactImpl

foreign import data YText :: Type

foreign import yTextToString :: YText -> String

foreign import mkYTextImpl :: EffectFn1 String YText

mkYText ∷ String → Effect YText
mkYText = runEffectFn1 mkYTextImpl

foreign import data YMap :: Type

foreign import mkYMap :: Effect YMap

foreign import getYMapImpl :: forall value. Fn2 YMap String value

getYMap ∷ ∀ (value ∷ Type). YMap → String → value
getYMap = runFn2 getYMapImpl

foreign import setYMapImpl :: forall value. EffectFn3 YMap String value Unit

setYMap ∷ ∀ (value ∷ Type). YMap → String → value → Effect Unit
setYMap = runEffectFn3 setYMapImpl

foreign import data YArray :: Type -> Type

instance Eq (YArray elem) where
  eq = unsafeEq

instance Observable (YArray elem) ArrayEvent where
  observe arr handler = runEffectFn2 unsafeObserveImpl arr handler
  observeDeep arr handler = runEffectFn2 unsafeObserveDeepImpl arr handler

instance Push (YArray elem) elem where
  push = runEffectFn2 unsafePushImpl

foreign import arrayToJSONImpl :: forall elem. YArray elem -> Array Foreign

instance ToJson (YArray elem) (Array Foreign) where
  toJSON = arrayToJSONImpl

foreign import data ArrayEvent :: Type

foreign import mapYArray :: forall a b. (a -> b) -> YArray a -> Array b

foreign import mapYArrayWithIndexImpl :: forall a b. (Fn2 a Int b) -> YArray a -> Array b

mapYArrayWithIndex ∷ ∀ (a ∷ Type) (b ∷ Type). (a → Int → b) → YArray a → Array b
mapYArrayWithIndex fn = mapYArrayWithIndexImpl (mkFn2 fn)

foreign import getArray :: forall elem. YDoc -> String -> Effect (YArray elem)

foreign import toArray :: forall elem. YArray elem -> Array elem

foreign import deleteAtImpl :: forall elem. EffectFn3 (YArray elem) Int Int Unit

deleteAt ∷ ∀ (elem ∷ Type). YArray elem → Int → Int → Effect Unit
deleteAt = runEffectFn3 deleteAtImpl

foreign import data YXmlText :: Type

foreign import mkYXmlTextImpl :: EffectFn1 String Unit

mkYXmlText ∷ String → Effect Unit
mkYXmlText = runEffectFn1 mkYXmlTextImpl

foreign import data YXmlFragment :: Type

instance Eq YXmlFragment where
  eq = unsafeEq

foreign import mkYXmlFragment :: Effect YXmlFragment

foreign import xmlFragmentToJSONImpl :: YXmlFragment -> String

instance ToJson YXmlFragment String where
  toJSON = xmlFragmentToJSONImpl

foreign import data XmlEvent :: Type

instance Observable YXmlFragment XmlEvent where
  observe xmlFragment handler = runEffectFn2 unsafeObserveImpl xmlFragment handler
  observeDeep xmlFragment handler = runEffectFn2 unsafeObserveDeepImpl xmlFragment handler

instance Push YXmlFragment elem where
  push = runEffectFn2 unsafePushImpl

foreign import insertYXmlFragmentImpl :: forall elem. EffectFn3 YXmlFragment elem Int Unit

instance Insert YXmlFragment elem where
  insert = runEffectFn3 insertYXmlFragmentImpl

foreign import toDOM :: YXmlFragment -> DocumentFragment

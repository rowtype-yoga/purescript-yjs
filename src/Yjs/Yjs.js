import * as Y from "yjs";

export const mkYDoc = () => new Y.Doc();

export const unsafeEq = (l) => (r) => l == r;

export const mkYTextImpl = (initialValue) => new Y.Text(initialValue);

export const mkYMap = () => new Y.Map();

export const getYMapImpl = (yMap, key) => yMap.get(key);
export const setYMapImpl = (yMap, key, value) => yMap.set(key, value);
export const mkYXmlFragment = () => {
  const yXmlFragment = new Y.XmlFragment();
  return yXmlFragment;
};

export const mkYXmlTextImpl = (content) => {
  return new Y.XmlText(content);
};

export const getArray = (yDoc) => (name) => () => {
  console.log("yDoc", yDoc.guid);
  return yDoc.getArray(name);
};

export const mapYArray = (fn) => (yArray) => yArray.map(fn);
export const mapYArrayWithIndexImpl = (fn) => (yArray) => yArray.map(fn);
export const toArray = (yarray) => yarray.toArray();

export const arrayToJSONImpl = (yarray) => yarray.toJSON();

export const xmlFragmentToJSONImpl = (xmlFragment) => xmlFragment.toJSON();

export const unsafeObserveImpl = (yarray, handler) => {
  yarray.observe(handler);
  return () => yarray.unobserve(handler);
};

export const unsafeObserveDeepImpl = (yarray, handler) => {
  yarray.observeDeep(handler);
  return () => yarray.unobserveDeep(handler);
};

export const yTextToString = (yText) => yText.toString();

export const deleteAtImpl = (yArray, index, length) => {
  yArray.delete(index, length);
};

export const unsafePushImpl = (t, elem) => {
  t.push([elem]);
};

export const insertYXmlFragmentImpl = (yXmlFragment, elem, index) => {
  yXmlFragment.insert(index, [elem]);
};

export const transactImpl = (yDoc, transaction, origin) => {
  yDoc.transact(transaction, origin);
};

export const toDOM = (yXmlFragment) => {
  return yXmlFragment.toDOM();
};

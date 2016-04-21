import Firebase from 'firebase';
import { observeStore } from './store';

let ref;

observeStore('app.appName', (appName) => {
  if (ref) ref.off();
  ref = new Firebase(`https://${appName}.firebaseio.com`);
});

export default function getFirebaseRef () {
  return ref;
}

import Firebase from 'firebase';

const appName = localStorage.appName || 'imalist';

export default new Firebase(`https://${appName}.firebaseio.com`);

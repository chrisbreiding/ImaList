import { asReference, observable } from 'mobx'

import C from '../data/constants'
import localStore from '../data/local-store'

class AppState {
  @observable app = asReference(null)
  @observable appName = localStore.get('appName') || 'imalist'
  @observable apiKey = localStore.get('apiKey')
  @observable attemptingClearCompleted = false
  @observable bulkAddingItems = false
  @observable editingItemId = null
  @observable firebaseApp = null
  @observable loadingData = false
  @observable showingFirebaseSettings = false
  @observable state = C.NEEDS_INITIALIZATION
}

export default new AppState()

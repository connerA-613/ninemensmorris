import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to game channel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const lobbyNumber = data['lobby_number'].toString()
    const urlLobbyNumber = window.location.href.split('/').pop()

    console.log(lobbyNumber, urlLobbyNumber)

    if (urlLobbyNumber.includes(lobbyNumber)) {
      window.location.replace('/game/'+lobbyNumber)
    }
  }
});

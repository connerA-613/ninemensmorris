import consumer from "./consumer"

consumer.subscriptions.create("LobbyChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to lobby channel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const lobbyNumber = data['lobby_number'].toString()
    const urlLobbyNumber = window.location.href.split('/').pop()

    if (lobbyNumber == urlLobbyNumber) {
      window.location.reload()
    }
  }
});

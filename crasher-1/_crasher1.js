(function () {
  // When I was working on my chat app, I tried to toggle between displaying a new overlay window, or using the tablet.
  // This attempt caused a hard crash.

  var app_is_visible = true;
  var AppUi = Script.require("appUi");
  var dummy_variable = false; // Intention: Whether or not the app should render in an overlay or the tablet

  // Global vars
  var tablet;
  var overlay_window;

  startup();

  function startup() {
    tablet = Tablet.getTablet("com.highfidelity.interface.tablet.system");

    var app_button = tablet.addButton({
      icon: Script.resolvePath("./img/icon.png"),
      text: "crsh1"
    });

    // When script ends, remove itself from tablet
    Script.scriptEnding.connect(function () {
      tablet.removeButton(app_button);
      overlay_window.close();
    });

    // if dummy_variable is false, use the overlay
    if (!dummy_variable) {
      overlay_window = new OverlayWebWindow({
        title: "crsh1",
        width: 350,
        height: 400,
        visible: app_is_visible,
        source: Script.resolvePath("./index.html")
      });
    }
    // If dummy_variable is true, use tablet
    else {
      overlay_window = new AppUi({
        buttonName: "crsh1",
        home: Script.resolvePath("./index.html"),
        graphicsDirectory: Script.resolvePath("./") // The path to your button icons
      });
    }

    // Overlay button toggle
    app_button.clicked.connect(toggleMainChatWindow);
    overlay_window.closed.connect(toggleMainChatWindow);

    function toggleMainChatWindow() {
      app_is_visible = !app_is_visible;
      app_button.editProperties({ isActive: app_is_visible });
      overlay_window.visible = app_is_visible;
    }
  }

  // Add event listeners
  overlay_window.webEventReceived.connect(onWebEventReceived);

  // function receivedMessage(channel, message) {}
  function onWebEventReceived(event) {
    console.log(event);
    event = JSON.parse(event);
    if (event.action === "change_to_true") {
      dummy_variable = true;
      overlay_window.close();
    }
  }
})();

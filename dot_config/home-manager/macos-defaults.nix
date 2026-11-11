# Explicit preferences captured from this Mac. Missing keys retain macOS defaults.
# Custom keys are macOS implementation details and may change between releases.
{
  system.defaults = {
    NSGlobalDomain = {
      "AppleKeyboardUIMode" = 0;
      "AppleMeasurementUnits" = "Centimeters";
      "AppleMetricUnits" = 1;
      "AppleShowScrollBars" = "Always";
      "AppleTemperatureUnit" = "Celsius";
      "InitialKeyRepeat" = 25; # Delay before a held key starts repeating; lower is faster.
      "KeyRepeat" = 1; # Interval between repeats; lower is faster.
      "NSAutomaticCapitalizationEnabled" = true;
      "NSAutomaticDashSubstitutionEnabled" = true;
      "NSAutomaticPeriodSubstitutionEnabled" = false;
      "NSAutomaticQuoteSubstitutionEnabled" = true;
      "NSAutomaticSpellingCorrectionEnabled" = false;
      "_HIHideMenuBar" = false;
      "com.apple.keyboard.fnState" = true;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.springing.delay" = 0.6000000000000001;
      "com.apple.springing.enabled" = true;
      "com.apple.trackpad.forceClick" = false;
      "com.apple.trackpad.scaling" = 0.875;
    };

    dock = {
      persistent-apps = [
        "/System/Applications/Mail.app"
        "/System/Applications/Messages.app"
        "/System/Applications/FaceTime.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Notes.app"
        "/System/Applications/Reminders.app"
        "/System/Applications/Maps.app"
        "/System/Applications/Photos.app"
      ];
      "autohide" = true;
      "largesize" = 16;
      "magnification" = false;
      "mineffect" = "scale";
      "minimize-to-application" = true;
      "orientation" = "left";
      "show-recents" = false;
      "showDesktopGestureEnabled" = true;
      "showMissionControlGestureEnabled" = true;
      "tilesize" = 38;
      "wvous-br-corner" = 14;
    };

    finder = {
      "FXPreferredViewStyle" = "Nlsv";
      "FXRemoveOldTrashItems" = true;
      "NewWindowTarget" = "Computer";
      "ShowExternalHardDrivesOnDesktop" = true;
      "ShowHardDrivesOnDesktop" = true;
      "ShowMountedServersOnDesktop" = false;
      "ShowPathbar" = true;
      "ShowRemovableMediaOnDesktop" = false;
      "ShowStatusBar" = true;
    };

    trackpad = {
      "ActuateDetents" = true;
      "Clicking" = false;
      "DragLock" = false;
      "Dragging" = false;
      "FirstClickThreshold" = 1;
      "ForceSuppressed" = false;
      "SecondClickThreshold" = 1;
      "TrackpadCornerSecondaryClick" = 0;
      "TrackpadFourFingerHorizSwipeGesture" = 2;
      "TrackpadFourFingerPinchGesture" = 2;
      "TrackpadFourFingerVertSwipeGesture" = 2;
      "TrackpadMomentumScroll" = true;
      "TrackpadPinch" = true;
      "TrackpadRightClick" = false;
      "TrackpadRotate" = true;
      "TrackpadThreeFingerDrag" = false;
      "TrackpadThreeFingerHorizSwipeGesture" = 0;
      "TrackpadThreeFingerTapGesture" = 2;
      "TrackpadThreeFingerVertSwipeGesture" = 2;
      "TrackpadTwoFingerDoubleTapGesture" = true;
      "TrackpadTwoFingerFromRightEdgeSwipeGesture" = 3;
    };

    menuExtraClock = {
      "FlashDateSeparators" = false;
      "IsAnalog" = false;
      "ShowAMPM" = true;
      "ShowDate" = 0;
      "ShowDayOfWeek" = true;
      "ShowSeconds" = false;
    };

    WindowManager = {
      "AppWindowGroupingBehavior" = true;
      "AutoHide" = false;
      "EnableTiledWindowMargins" = false;
      "GloballyEnabled" = false;
      "HideDesktop" = true;
      "StageManagerHideWidgets" = false;
      "StandardHideWidgets" = false;
    };

    universalaccess = {
      "closeViewScrollWheelToggle" = true;
      "mouseDriverCursorSize" = 1.0;
      "reduceTransparency" = false;
    };

    CustomUserPreferences = {
      "NSGlobalDomain" = {
        "AppleActionOnDoubleClick" = "Maximize";
        "AppleAquaColorVariant" = 1;
        "AppleICUForce12HourTime" = true;
        "AppleLanguages" = [
          "en-US"
          "fr-FR"
        ];
        "AppleLocale" = "en_US@rg=frzzzz";
        "AppleMenuBarVisibleInFullscreen" = false;
        "AppleMiniaturizeOnDoubleClick" = false;
        "NSAutomaticTextCompletionEnabled" = true;
        "NSSpellCheckerAutomaticallyIdentifiesLanguages" = true;
        "NSPreferredSpellServerLanguage" = "fr";
        "WebAutomaticSpellingCorrectionEnabled" = false;
        "com.apple.mouse.doubleClickThreshold" = 0.5;
        "com.apple.mouse.scaling" = 2.0;
        "com.apple.sound.beep.flash" = 0;
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Tink.aiff";
        "com.apple.sound.uiaudio.enabled" = 1;
      };
      "com.apple.dock" = {
        "enterMissionControlByTopWindowDrag" = false;
        "wvous-br-modifier" = 0;
      };
      "com.apple.finder" = {
        "ShowRecentTags" = false;
      };
      "com.apple.AppleMultitouchTrackpad" = {
        "HIDScrollZoomModifierMask" = 262144;
        "TrackpadFiveFingerPinchGesture" = 2;
        "TrackpadHandResting" = true;
        "TrackpadHorizScroll" = 1;
        "TrackpadScroll" = true;
        "USBMouseStopsTrackpad" = 0;
      };
      "com.apple.universalaccess" = {
        "closeViewHotkeysEnabled" = false;
        "closeViewScrollWheelModifiersInt" = 262144;
        "closeViewTrackpadGestureZoomEnabled" = false;
        "contrast" = 0.0;
        "differentiateWithoutColor" = false;
        "grayscale" = false;
        "hoverTextEnabled" = false;
        "hoverTypingEnabled" = false;
        "showToolbarButtonShapes" = false;
        "showWindowTitlebarIcons" = false;
        "slowKey" = false;
        "slowKeyDelay" = 250;
        "stickyKey" = false;
        "useStickyKeysShortcutKeys" = false;
        "voiceOverOnOffKey" = false;
        "whiteOnBlack" = false;
      };
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        "Clicking" = false;
        "DragLock" = false;
        "Dragging" = false;
        "HIDScrollZoomModifierMask" = 262144;
        "TrackpadCornerSecondaryClick" = 0;
        "TrackpadFiveFingerPinchGesture" = 2;
        "TrackpadFourFingerHorizSwipeGesture" = 2;
        "TrackpadFourFingerPinchGesture" = 2;
        "TrackpadFourFingerVertSwipeGesture" = 2;
        "TrackpadHandResting" = true;
        "TrackpadHorizScroll" = 1;
        "TrackpadMomentumScroll" = true;
        "TrackpadPinch" = 1;
        "TrackpadRightClick" = false;
        "TrackpadRotate" = 1;
        "TrackpadScroll" = true;
        "TrackpadThreeFingerDrag" = false;
        "TrackpadThreeFingerHorizSwipeGesture" = 0;
        "TrackpadThreeFingerTapGesture" = 2;
        "TrackpadThreeFingerVertSwipeGesture" = 2;
        "TrackpadTwoFingerDoubleTapGesture" = 1;
        "TrackpadTwoFingerFromRightEdgeSwipeGesture" = 3;
        "USBMouseStopsTrackpad" = 0;
      };
      "com.apple.HIToolbox" = {
        "AppleEnabledInputSources" = [
          {
            "InputSourceKind" = "Keyboard Layout";
            "KeyboardLayout ID" = 1;
            "KeyboardLayout Name" = "French";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            "InputSourceKind" = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.inputmethod.ironwood";
            "InputSourceKind" = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.PressAndHold";
            "InputSourceKind" = "Non Keyboard Input Method";
          }
        ];
        "AppleSelectedInputSources" = [
          {
            "Bundle ID" = "com.apple.PressAndHold";
            "InputSourceKind" = "Non Keyboard Input Method";
          }
          {
            "InputSourceKind" = "Keyboard Layout";
            "KeyboardLayout ID" = 1;
            "KeyboardLayout Name" = "French";
          }
        ];
        "AppleFnUsageType" = 0;
      };
      "com.apple.symbolichotkeys".AppleSymbolicHotKeys = builtins.fromJSON (
        builtins.readFile ./macos-shortcuts.json
      );
    };
  };
}

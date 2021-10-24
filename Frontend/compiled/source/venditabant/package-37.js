(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.container.Composite": {
        "construct": true,
        "require": true
      },
      "qx.ui.layout.HBox": {
        "construct": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Sebastian Werner (wpbasti)
       * Andreas Ecker (ecker)
       * Jonathan Weiß (jonathan_rass)
  
  ************************************************************************ */

  /**
   * The container used by {@link Part} to insert the buttons.
   *
   * @internal
   */
  qx.Class.define("qx.ui.toolbar.PartContainer", {
    extend: qx.ui.container.Composite,
    construct: function construct() {
      qx.ui.container.Composite.constructor.call(this);

      this._setLayout(new qx.ui.layout.HBox());
    },
    events: {
      /** Fired if a child has been added or removed */
      changeChildren: "qx.event.type.Event"
    },
    properties: {
      appearance: {
        refine: true,
        init: "toolbar/part/container"
      },

      /** Whether icons, labels, both or none should be shown. */
      show: {
        init: "both",
        check: ["both", "label", "icon"],
        inheritable: true,
        event: "changeShow"
      }
    },
    members: {
      // overridden
      _afterAddChild: function _afterAddChild(child) {
        this.fireEvent("changeChildren");
      },
      // overridden
      _afterRemoveChild: function _afterRemoveChild(child) {
        this.fireEvent("changeChildren");
      }
    }
  });
  qx.ui.toolbar.PartContainer.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.basic.Atom": {
        "construct": true,
        "require": true
      },
      "qx.ui.core.MExecutable": {
        "require": true
      },
      "qx.ui.form.IExecutable": {
        "require": true
      },
      "qx.event.AcceleratingTimer": {
        "construct": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2009 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * The HoverButton is an {@link qx.ui.basic.Atom}, which fires repeatedly
   * execute events while the pointer is over the widget.
   *
   * The rate at which the execute event is fired accelerates is the pointer keeps
   * inside of the widget. The initial delay and the interval time can be set using
   * the properties {@link #firstInterval} and {@link #interval}. The
   * {@link #execute} events will be fired in a shorter amount of time if the pointer
   * remains over the widget, until the min {@link #minTimer} is reached.
   * The {@link #timerDecrease} property sets the amount of milliseconds which will
   * decreased after every firing.
   *
   * *Example*
   *
   * Here is a little example of how to use the widget.
   *
   * <pre class='javascript'>
   *   var button = new qx.ui.form.HoverButton("Hello World");
   *
   *   button.addListener("execute", function(e) {
   *     alert("Button is hovered");
   *   }, this);
   *
   *   this.getRoot.add(button);
   * </pre>
   *
   * This example creates a button with the label "Hello World" and attaches an
   * event listener to the {@link #execute} event.
   *
   * *External Documentation*
   *
   * <a href='http://qooxdoo.org/docs/#desktop/widget/hoverbutton.md' target='_blank'>
   * Documentation of this widget in the qooxdoo manual.</a>
   */
  qx.Class.define("qx.ui.form.HoverButton", {
    extend: qx.ui.basic.Atom,
    include: [qx.ui.core.MExecutable],
    implement: [qx.ui.form.IExecutable],

    /**
     * @param label {String} Label to use
     * @param icon {String?null} Icon to use
     */
    construct: function construct(label, icon) {
      qx.ui.basic.Atom.constructor.call(this, label, icon);
      this.addListener("pointerover", this._onPointerOver, this);
      this.addListener("pointerout", this._onPointerOut, this);
      this.__timer__P_187_0 = new qx.event.AcceleratingTimer();

      this.__timer__P_187_0.addListener("interval", this._onInterval, this);
    },
    properties: {
      // overridden
      appearance: {
        refine: true,
        init: "hover-button"
      },

      /**
       * Interval used after the first run of the timer. Usually a smaller value
       * than the "firstInterval" property value to get a faster reaction.
       */
      interval: {
        check: "Integer",
        init: 80
      },

      /**
       * Interval used for the first run of the timer. Usually a greater value
       * than the "interval" property value to a little delayed reaction at the first
       * time.
       */
      firstInterval: {
        check: "Integer",
        init: 200
      },

      /** This configures the minimum value for the timer interval. */
      minTimer: {
        check: "Integer",
        init: 20
      },

      /** Decrease of the timer on each interval (for the next interval) until minTimer reached. */
      timerDecrease: {
        check: "Integer",
        init: 2
      }
    },
    members: {
      __timer__P_187_0: null,

      /**
       * Start timer on pointer over
       *
       * @param e {qx.event.type.Pointer} The pointer event
       */
      _onPointerOver: function _onPointerOver(e) {
        if (!this.isEnabled() || e.getTarget() !== this) {
          return;
        }

        this.__timer__P_187_0.set({
          interval: this.getInterval(),
          firstInterval: this.getFirstInterval(),
          minimum: this.getMinTimer(),
          decrease: this.getTimerDecrease()
        }).start();

        this.addState("hovered");
      },

      /**
       * Stop timer on pointer out
       *
       * @param e {qx.event.type.Pointer} The pointer event
       */
      _onPointerOut: function _onPointerOut(e) {
        this.__timer__P_187_0.stop();

        this.removeState("hovered");

        if (!this.isEnabled() || e.getTarget() !== this) {
          return;
        }
      },

      /**
       * Fire execute event on timer interval event
       */
      _onInterval: function _onInterval() {
        if (this.isEnabled()) {
          this.execute();
        } else {
          this.__timer__P_187_0.stop();
        }
      }
    },
    destruct: function destruct() {
      this._disposeObjects("__timer__P_187_0");
    }
  });
  qx.ui.form.HoverButton.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.core.Object": {
        "construct": true,
        "require": true
      },
      "qx.event.Timer": {},
      "qx.bom.element.Dimension": {},
      "qx.lang.Object": {},
      "qx.bom.element.Style": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2011 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
  ************************************************************************ */

  /**
   * Checks whether a given font is available on the document and fires events
   * accordingly.
   * 
   * This class does not need to be disposed, unless you want to abort the validation
   * early
   */
  qx.Class.define("qx.bom.webfonts.Validator", {
    extend: qx.core.Object,

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param fontFamily {String} The name of the font to be verified
     * @param comparisonString {String?} String to be used to detect whether a font was loaded or not
     * @param fontWeight {String?} the weight of the font to be verified
     * @param fontStyle {String?} the style of the font to be verified
     * whether the font has loaded properly
     */
    construct: function construct(fontFamily, comparisonString, fontWeight, fontStyle) {
      qx.core.Object.constructor.call(this);

      if (comparisonString) {
        this.setComparisonString(comparisonString);
      }

      if (fontWeight) {
        this.setFontWeight(fontWeight);
      }

      if (fontStyle) {
        this.setFontStyle(fontStyle);
      }

      if (fontFamily) {
        this.setFontFamily(fontFamily);
        this.__requestedHelpers__P_159_0 = this._getRequestedHelpers();
      }
    },

    /*
    *****************************************************************************
       STATICS
    *****************************************************************************
    */
    statics: {
      /**
       * Sets of serif and sans-serif fonts to be used for size comparisons.
       * At least one of these fonts should be present on any system.
       */
      COMPARISON_FONTS: {
        sans: ["Arial", "Helvetica", "sans-serif"],
        serif: ["Times New Roman", "Georgia", "serif"]
      },

      /**
       * Map of common CSS attributes to be used for all  size comparison elements
       */
      HELPER_CSS: {
        position: "absolute",
        margin: "0",
        padding: "0",
        top: "-1000px",
        left: "-1000px",
        fontSize: "350px",
        width: "auto",
        height: "auto",
        lineHeight: "normal",
        fontVariant: "normal",
        visibility: "hidden"
      },

      /**
       * The string to be used in the size comparison elements. This is the default string
       * which is used for the {@link #COMPARISON_FONTS} and the font to be validated. It
       * can be overridden for the font to be validated using the {@link #comparisonString}
       * property.
       */
      COMPARISON_STRING: "WEei",
      __defaultSizes__P_159_1: null,
      __defaultHelpers__P_159_2: null,

      /**
       * Removes the two common helper elements used for all size comparisons from
       * the DOM
       */
      removeDefaultHelperElements: function removeDefaultHelperElements() {
        var defaultHelpers = qx.bom.webfonts.Validator.__defaultHelpers__P_159_2;

        if (defaultHelpers) {
          for (var prop in defaultHelpers) {
            document.body.removeChild(defaultHelpers[prop]);
          }
        }

        delete qx.bom.webfonts.Validator.__defaultHelpers__P_159_2;
      }
    },

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      /**
       * The font-family this validator should check
       */
      fontFamily: {
        nullable: true,
        init: null,
        apply: "_applyFontFamily"
      },

      /** The font weight to check */
      fontWeight: {
        nullable: true,
        check: "String",
        apply: "_applyFontWeight"
      },

      /** The font style to check */
      fontStyle: {
        nullable: true,
        check: "String",
        apply: "_applyFontStyle"
      },

      /**
       * Comparison string used to check whether the font has loaded or not.
       */
      comparisonString: {
        nullable: true,
        init: null
      },

      /**
       * Time in milliseconds from the beginning of the check until it is assumed
       * that a font is not available
       */
      timeout: {
        check: "Integer",
        init: 5000
      }
    },

    /*
    *****************************************************************************
       EVENTS
    *****************************************************************************
    */
    events: {
      /**
       * Fired when the status of a web font has been determined. The event data
       * is a map with the keys "family" (the font-family name) and "valid"
       * (Boolean).
       */
      "changeStatus": "qx.event.type.Data"
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      __requestedHelpers__P_159_0: null,
      __checkTimer__P_159_3: null,
      __checkStarted__P_159_4: null,

      /*
      ---------------------------------------------------------------------------
        PUBLIC API
      ---------------------------------------------------------------------------
      */

      /**
       * Validates the font
       */
      validate: function validate() {
        this.__checkStarted__P_159_4 = new Date().getTime();

        if (this.__checkTimer__P_159_3) {
          this.__checkTimer__P_159_3.restart();
        } else {
          this.__checkTimer__P_159_3 = new qx.event.Timer(100);

          this.__checkTimer__P_159_3.addListener("interval", this.__onTimerInterval__P_159_5, this); // Give the browser a chance to render the new elements


          qx.event.Timer.once(function () {
            this.__checkTimer__P_159_3.start();
          }, this, 0);
        }
      },

      /*
      ---------------------------------------------------------------------------
        PROTECTED API
      ---------------------------------------------------------------------------
      */

      /**
       * Removes the helper elements from the DOM
       */
      _reset: function _reset() {
        if (this.__requestedHelpers__P_159_0) {
          for (var prop in this.__requestedHelpers__P_159_0) {
            var elem = this.__requestedHelpers__P_159_0[prop];
            document.body.removeChild(elem);
          }

          this.__requestedHelpers__P_159_0 = null;
        }
      },

      /**
       * Checks if the font is available by comparing the widths of the elements
       * using the generic fonts to the widths of the elements using the font to
       * be validated
       *
       * @return {Boolean} Whether or not the font caused the elements to differ
       * in size
       */
      _isFontValid: function _isFontValid() {
        if (!qx.bom.webfonts.Validator.__defaultSizes__P_159_1) {
          this.__init__P_159_6();
        }

        if (!this.__requestedHelpers__P_159_0) {
          this.__requestedHelpers__P_159_0 = this._getRequestedHelpers();
        } // force rerendering for chrome


        this.__requestedHelpers__P_159_0.sans.style.visibility = "visible";
        this.__requestedHelpers__P_159_0.sans.style.visibility = "hidden";
        this.__requestedHelpers__P_159_0.serif.style.visibility = "visible";
        this.__requestedHelpers__P_159_0.serif.style.visibility = "hidden";
        var requestedSans = qx.bom.element.Dimension.getWidth(this.__requestedHelpers__P_159_0.sans);
        var requestedSerif = qx.bom.element.Dimension.getWidth(this.__requestedHelpers__P_159_0.serif);
        var cls = qx.bom.webfonts.Validator;

        if (requestedSans !== cls.__defaultSizes__P_159_1.sans || requestedSerif !== cls.__defaultSizes__P_159_1.serif) {
          return true;
        }

        return false;
      },

      /**
       * Creates the two helper elements styled with the font to be checked
       *
       * @return {Map} A map with the keys <pre>sans</pre> and <pre>serif</pre>
       * and the created span elements as values
       */
      _getRequestedHelpers: function _getRequestedHelpers() {
        var fontsSans = [this.getFontFamily()].concat(qx.bom.webfonts.Validator.COMPARISON_FONTS.sans);
        var fontsSerif = [this.getFontFamily()].concat(qx.bom.webfonts.Validator.COMPARISON_FONTS.serif);
        return {
          sans: this._getHelperElement(fontsSans, this.getComparisonString()),
          serif: this._getHelperElement(fontsSerif, this.getComparisonString())
        };
      },

      /**
       * Creates a span element with the comparison text (either {@link #COMPARISON_STRING} or
       * {@link #comparisonString}) and styled with the default CSS ({@link #HELPER_CSS}) plus
       * the given font-family value and appends it to the DOM
       *
       * @param fontFamily {String} font-family string
       * @param comparisonString {String?} String to be used to detect whether a font was loaded or not
       * @return {Element} the created DOM element
       */
      _getHelperElement: function _getHelperElement(fontFamily, comparisonString) {
        var styleMap = qx.lang.Object.clone(qx.bom.webfonts.Validator.HELPER_CSS);

        if (fontFamily) {
          if (styleMap.fontFamily) {
            styleMap.fontFamily += "," + fontFamily.join(",");
          } else {
            styleMap.fontFamily = fontFamily.join(",");
          }
        }

        if (this.getFontWeight()) {
          styleMap.fontWeight = this.getFontWeight();
        }

        if (this.getFontStyle()) {
          styleMap.fontStyle = this.getFontStyle();
        }

        var elem = document.createElement("span");
        elem.innerHTML = comparisonString || qx.bom.webfonts.Validator.COMPARISON_STRING;
        qx.bom.element.Style.setStyles(elem, styleMap);
        document.body.appendChild(elem);
        return elem;
      },
      // property apply
      _applyFontFamily: function _applyFontFamily(value, old) {
        if (value !== old) {
          this._reset();
        }
      },
      // property apply
      _applyFontWeight: function _applyFontWeight(value, old) {
        if (value !== old) {
          this._reset();
        }
      },
      // property apply
      _applyFontStyle: function _applyFontStyle(value, old) {
        if (value !== old) {
          this._reset();
        }
      },

      /*
      ---------------------------------------------------------------------------
        PRIVATE API
      ---------------------------------------------------------------------------
      */

      /**
       * Creates the default helper elements and gets their widths
       */
      __init__P_159_6: function __init__P_159_6() {
        var cls = qx.bom.webfonts.Validator;

        if (!cls.__defaultHelpers__P_159_2) {
          cls.__defaultHelpers__P_159_2 = {
            sans: this._getHelperElement(cls.COMPARISON_FONTS.sans),
            serif: this._getHelperElement(cls.COMPARISON_FONTS.serif)
          };
        }

        cls.__defaultSizes__P_159_1 = {
          sans: qx.bom.element.Dimension.getWidth(cls.__defaultHelpers__P_159_2.sans),
          serif: qx.bom.element.Dimension.getWidth(cls.__defaultHelpers__P_159_2.serif)
        };
      },

      /**
       * Triggers helper element size comparison and fires a ({@link #changeStatus})
       * event with the result.
       */
      __onTimerInterval__P_159_5: function __onTimerInterval__P_159_5() {
        if (this._isFontValid()) {
          this.__checkTimer__P_159_3.stop();

          this._reset();

          this.fireDataEvent("changeStatus", {
            family: this.getFontFamily(),
            valid: true
          });
        } else {
          var now = new Date().getTime();

          if (now - this.__checkStarted__P_159_4 >= this.getTimeout()) {
            this.__checkTimer__P_159_3.stop();

            this._reset();

            this.fireDataEvent("changeStatus", {
              family: this.getFontFamily(),
              valid: false
            });
          }
        }
      }
    },

    /*
    *****************************************************************************
       DESTRUCTOR
    *****************************************************************************
    */
    destruct: function destruct() {
      this._reset();

      this.__checkTimer__P_159_3.stop();

      this.__checkTimer__P_159_3.removeListener("interval", this.__onTimerInterval__P_159_5, this);

      this._disposeObjects("__checkTimer__P_159_3");
    }
  });
  qx.bom.webfonts.Validator.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Interface": {
        "usage": "dynamic",
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2009 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Christian Hagendorn (chris_schmidt)
  
  ************************************************************************ */

  /**
   * Defines the callback for the single selection manager.
   *
   * @internal
   */
  qx.Interface.define("qx.ui.core.ISingleSelectionProvider", {
    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      /**
       * Returns the elements which are part of the selection.
       *
       * @return {qx.ui.core.Widget[]} The widgets for the selection.
       */
      getItems: function getItems() {},

      /**
       * Returns whether the given item is selectable.
       *
       * @param item {qx.ui.core.Widget} The item to be checked
       * @return {Boolean} Whether the given item is selectable
       */
      isItemSelectable: function isItemSelectable(item) {}
    }
  });
  qx.ui.core.ISingleSelectionProvider.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.core.Object": {
        "construct": true,
        "require": true
      },
      "qx.core.IDisposable": {
        "require": true
      },
      "qx.event.Timer": {
        "construct": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2009 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * Timer, which accelerates after each interval. The initial delay and the
   * interval time can be set using the properties {@link #firstInterval}
   * and {@link #interval}. The {@link #interval} events will be fired with
   * decreasing interval times while the timer is running, until the {@link #minimum}
   * is reached. The {@link #decrease} property sets the amount of milliseconds
   * which will decreased after every firing.
   *
   * This class is e.g. used in the {@link qx.ui.form.RepeatButton} and
   * {@link qx.ui.form.HoverButton} widgets.
   * 
   * NOTE: Instances of this class must be disposed of after use
   *
   */
  qx.Class.define("qx.event.AcceleratingTimer", {
    extend: qx.core.Object,
    implement: [qx.core.IDisposable],
    construct: function construct() {
      qx.core.Object.constructor.call(this);
      this.__timer__P_190_0 = new qx.event.Timer(this.getInterval());

      this.__timer__P_190_0.addListener("interval", this._onInterval, this);
    },
    events: {
      /** This event if fired each time the interval time has elapsed */
      "interval": "qx.event.type.Event"
    },
    properties: {
      /**
       * Interval used after the first run of the timer. Usually a smaller value
       * than the "firstInterval" property value to get a faster reaction.
       */
      interval: {
        check: "Integer",
        init: 100
      },

      /**
       * Interval used for the first run of the timer. Usually a greater value
       * than the "interval" property value to a little delayed reaction at the first
       * time.
       */
      firstInterval: {
        check: "Integer",
        init: 500
      },

      /** This configures the minimum value for the timer interval. */
      minimum: {
        check: "Integer",
        init: 20
      },

      /** Decrease of the timer on each interval (for the next interval) until minTimer reached. */
      decrease: {
        check: "Integer",
        init: 2
      }
    },
    members: {
      __timer__P_190_0: null,
      __currentInterval__P_190_1: null,

      /**
       * Reset and start the timer.
       */
      start: function start() {
        this.__timer__P_190_0.setInterval(this.getFirstInterval());

        this.__timer__P_190_0.start();
      },

      /**
       * Stop the timer
       */
      stop: function stop() {
        this.__timer__P_190_0.stop();

        this.__currentInterval__P_190_1 = null;
      },

      /**
       * Interval event handler
       */
      _onInterval: function _onInterval() {
        this.__timer__P_190_0.stop();

        if (this.__currentInterval__P_190_1 == null) {
          this.__currentInterval__P_190_1 = this.getInterval();
        }

        this.__currentInterval__P_190_1 = Math.max(this.getMinimum(), this.__currentInterval__P_190_1 - this.getDecrease());

        this.__timer__P_190_0.setInterval(this.__currentInterval__P_190_1);

        this.__timer__P_190_0.start();

        this.fireEvent("interval");
      }
    },
    destruct: function destruct() {
      this._disposeObjects("__timer__P_190_0");
    }
  });
  qx.event.AcceleratingTimer.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.menu.AbstractButton": {
        "construct": true,
        "require": true
      },
      "qx.ui.form.IBooleanForm": {
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Sebastian Werner (wpbasti)
       * Fabian Jakobs (fjakobs)
       * Martin Wittemann (martinwittemann)
  
  ************************************************************************ */

  /**
   * Renders a special checkbox button inside a menu. The button behaves like
   * a normal {@link qx.ui.form.CheckBox} and shows a check icon when
   * checked; normally shows no icon when not checked (depends on the theme).
   */
  qx.Class.define("qx.ui.menu.CheckBox", {
    extend: qx.ui.menu.AbstractButton,
    implement: [qx.ui.form.IBooleanForm],

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param label {String} Initial label
     * @param menu {qx.ui.menu.Menu} Initial sub menu
     */
    construct: function construct(label, menu) {
      qx.ui.menu.AbstractButton.constructor.call(this); // Initialize with incoming arguments

      if (label != null) {
        // try to translate every time you create a checkbox [BUG #2699]
        if (label.translate) {
          this.setLabel(label.translate());
        } else {
          this.setLabel(label);
        }
      }

      if (menu != null) {
        this.setMenu(menu);
      }

      this.addListener("execute", this._onExecute, this);
    },

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      // overridden
      appearance: {
        refine: true,
        init: "menu-checkbox"
      },

      /** Whether the button is checked */
      value: {
        check: "Boolean",
        init: false,
        apply: "_applyValue",
        event: "changeValue",
        nullable: true
      }
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      // overridden (from MExecutable to keep the icon out of the binding)

      /**
       * @lint ignoreReferenceField(_bindableProperties)
       */
      _bindableProperties: ["enabled", "label", "toolTipText", "value", "menu"],
      // property apply
      _applyValue: function _applyValue(value, old) {
        value ? this.addState("checked") : this.removeState("checked");
      },

      /**
       * Handler for the execute event.
       *
       * @param e {qx.event.type.Event} The execute event.
       */
      _onExecute: function _onExecute(e) {
        this.toggleValue();
      }
    }
  });
  qx.ui.menu.CheckBox.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.menu.CheckBox": {
        "construct": true,
        "require": true
      },
      "qx.ui.table.IColumnMenuItem": {
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2009 Derrell Lipman
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Derrell Lipman (derrell)
  
  ************************************************************************ */

  /**
   * A menu item.
   */
  qx.Class.define("qx.ui.table.columnmenu.MenuItem", {
    extend: qx.ui.menu.CheckBox,
    implement: qx.ui.table.IColumnMenuItem,

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * Create a new instance of an item for insertion into the table column
     * visibility menu.
     *
     * @param text {String}
     *   Text for the menu item, most typically the name of the column in the
     *   table.
     */
    construct: function construct(text) {
      qx.ui.menu.CheckBox.constructor.call(this, text); // Two way binding this.columnVisible <--> this.value

      this.bind("value", this, "columnVisible");
      this.bind("columnVisible", this, "value");
    },

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      columnVisible: {
        check: "Boolean",
        init: true,
        event: "changeColumnVisible"
      }
    }
  });
  qx.ui.table.columnmenu.MenuItem.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.container.Composite": {
        "construct": true,
        "require": true
      },
      "qx.ui.layout.Grid": {
        "construct": true
      },
      "qx.ui.basic.Label": {},
      "qx.ui.basic.Image": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2006 STZ-IDA, Germany, http://www.stz-ida.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * The default header cell widget
   *
   * @childControl label {qx.ui.basic.Label} label of the header cell
   * @childControl sort-icon {qx.ui.basic.Image} sort icon of the header cell
   * @childControl icon {qx.ui.basic.Image} icon of the header cell
   */
  qx.Class.define("qx.ui.table.headerrenderer.HeaderCell", {
    extend: qx.ui.container.Composite,
    construct: function construct() {
      qx.ui.container.Composite.constructor.call(this);
      var layout = new qx.ui.layout.Grid();
      layout.setRowFlex(0, 1);
      layout.setColumnFlex(1, 1);
      layout.setColumnFlex(2, 1);
      this.setLayout(layout);
    },
    properties: {
      appearance: {
        refine: true,
        init: "table-header-cell"
      },

      /** header cell label */
      label: {
        check: "String",
        init: null,
        nullable: true,
        apply: "_applyLabel"
      },

      /** The icon URL of the sorting indicator */
      sortIcon: {
        check: "String",
        init: null,
        nullable: true,
        apply: "_applySortIcon",
        themeable: true
      },

      /** Icon URL */
      icon: {
        check: "String",
        init: null,
        nullable: true,
        apply: "_applyIcon"
      }
    },
    members: {
      // property apply
      _applyLabel: function _applyLabel(value, old) {
        if (value) {
          this._showChildControl("label").setValue(value);
        } else {
          this._excludeChildControl("label");
        }
      },
      // property apply
      _applySortIcon: function _applySortIcon(value, old) {
        if (value) {
          this._showChildControl("sort-icon").setSource(value);
        } else {
          this._excludeChildControl("sort-icon");
        }
      },
      // property apply
      _applyIcon: function _applyIcon(value, old) {
        if (value) {
          this._showChildControl("icon").setSource(value);
        } else {
          this._excludeChildControl("icon");
        }
      },
      // overridden
      _createChildControlImpl: function _createChildControlImpl(id, hash) {
        var control;

        switch (id) {
          case "label":
            control = new qx.ui.basic.Label(this.getLabel()).set({
              anonymous: true,
              allowShrinkX: true
            });

            this._add(control, {
              row: 0,
              column: 1
            });

            break;

          case "sort-icon":
            control = new qx.ui.basic.Image(this.getSortIcon());
            control.setAnonymous(true);

            this._add(control, {
              row: 0,
              column: 2
            });

            break;

          case "icon":
            control = new qx.ui.basic.Image(this.getIcon()).set({
              anonymous: true,
              allowShrinkX: true
            });

            this._add(control, {
              row: 0,
              column: 0
            });

            break;
        }

        return control || qx.ui.table.headerrenderer.HeaderCell.prototype._createChildControlImpl.base.call(this, id);
      }
    }
  });
  qx.ui.table.headerrenderer.HeaderCell.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Bootstrap": {
        "usage": "dynamic",
        "require": true
      },
      "qx.util.StringEscape": {},
      "qx.lang.Object": {
        "defer": "runtime"
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * A Collection of utility functions to escape and unescape strings.
   */
  qx.Bootstrap.define("qx.bom.String", {
    /*
    *****************************************************************************
       STATICS
    *****************************************************************************
    */
    statics: {
      /** Mapping of HTML entity names to the corresponding char code */
      TO_CHARCODE: {
        "quot": 34,
        // " - double-quote
        "amp": 38,
        // &
        "lt": 60,
        // <
        "gt": 62,
        // >
        // http://www.w3.org/TR/REC-html40/sgml/entities.html
        // ISO 8859-1 characters
        "nbsp": 160,
        // no-break space
        "iexcl": 161,
        // inverted exclamation mark
        "cent": 162,
        // cent sign
        "pound": 163,
        // pound sterling sign
        "curren": 164,
        // general currency sign
        "yen": 165,
        // yen sign
        "brvbar": 166,
        // broken (vertical) bar
        "sect": 167,
        // section sign
        "uml": 168,
        // umlaut (dieresis)
        "copy": 169,
        // copyright sign
        "ordf": 170,
        // ordinal indicator, feminine
        "laquo": 171,
        // angle quotation mark, left
        "not": 172,
        // not sign
        "shy": 173,
        // soft hyphen
        "reg": 174,
        // registered sign
        "macr": 175,
        // macron
        "deg": 176,
        // degree sign
        "plusmn": 177,
        // plus-or-minus sign
        "sup2": 178,
        // superscript two
        "sup3": 179,
        // superscript three
        "acute": 180,
        // acute accent
        "micro": 181,
        // micro sign
        "para": 182,
        // pilcrow (paragraph sign)
        "middot": 183,
        // middle dot
        "cedil": 184,
        // cedilla
        "sup1": 185,
        // superscript one
        "ordm": 186,
        // ordinal indicator, masculine
        "raquo": 187,
        // angle quotation mark, right
        "frac14": 188,
        // fraction one-quarter
        "frac12": 189,
        // fraction one-half
        "frac34": 190,
        // fraction three-quarters
        "iquest": 191,
        // inverted question mark
        "Agrave": 192,
        // capital A, grave accent
        "Aacute": 193,
        // capital A, acute accent
        "Acirc": 194,
        // capital A, circumflex accent
        "Atilde": 195,
        // capital A, tilde
        "Auml": 196,
        // capital A, dieresis or umlaut mark
        "Aring": 197,
        // capital A, ring
        "AElig": 198,
        // capital AE diphthong (ligature)
        "Ccedil": 199,
        // capital C, cedilla
        "Egrave": 200,
        // capital E, grave accent
        "Eacute": 201,
        // capital E, acute accent
        "Ecirc": 202,
        // capital E, circumflex accent
        "Euml": 203,
        // capital E, dieresis or umlaut mark
        "Igrave": 204,
        // capital I, grave accent
        "Iacute": 205,
        // capital I, acute accent
        "Icirc": 206,
        // capital I, circumflex accent
        "Iuml": 207,
        // capital I, dieresis or umlaut mark
        "ETH": 208,
        // capital Eth, Icelandic
        "Ntilde": 209,
        // capital N, tilde
        "Ograve": 210,
        // capital O, grave accent
        "Oacute": 211,
        // capital O, acute accent
        "Ocirc": 212,
        // capital O, circumflex accent
        "Otilde": 213,
        // capital O, tilde
        "Ouml": 214,
        // capital O, dieresis or umlaut mark
        "times": 215,
        // multiply sign
        "Oslash": 216,
        // capital O, slash
        "Ugrave": 217,
        // capital U, grave accent
        "Uacute": 218,
        // capital U, acute accent
        "Ucirc": 219,
        // capital U, circumflex accent
        "Uuml": 220,
        // capital U, dieresis or umlaut mark
        "Yacute": 221,
        // capital Y, acute accent
        "THORN": 222,
        // capital THORN, Icelandic
        "szlig": 223,
        // small sharp s, German (sz ligature)
        "agrave": 224,
        // small a, grave accent
        "aacute": 225,
        // small a, acute accent
        "acirc": 226,
        // small a, circumflex accent
        "atilde": 227,
        // small a, tilde
        "auml": 228,
        // small a, dieresis or umlaut mark
        "aring": 229,
        // small a, ring
        "aelig": 230,
        // small ae diphthong (ligature)
        "ccedil": 231,
        // small c, cedilla
        "egrave": 232,
        // small e, grave accent
        "eacute": 233,
        // small e, acute accent
        "ecirc": 234,
        // small e, circumflex accent
        "euml": 235,
        // small e, dieresis or umlaut mark
        "igrave": 236,
        // small i, grave accent
        "iacute": 237,
        // small i, acute accent
        "icirc": 238,
        // small i, circumflex accent
        "iuml": 239,
        // small i, dieresis or umlaut mark
        "eth": 240,
        // small eth, Icelandic
        "ntilde": 241,
        // small n, tilde
        "ograve": 242,
        // small o, grave accent
        "oacute": 243,
        // small o, acute accent
        "ocirc": 244,
        // small o, circumflex accent
        "otilde": 245,
        // small o, tilde
        "ouml": 246,
        // small o, dieresis or umlaut mark
        "divide": 247,
        // divide sign
        "oslash": 248,
        // small o, slash
        "ugrave": 249,
        // small u, grave accent
        "uacute": 250,
        // small u, acute accent
        "ucirc": 251,
        // small u, circumflex accent
        "uuml": 252,
        // small u, dieresis or umlaut mark
        "yacute": 253,
        // small y, acute accent
        "thorn": 254,
        // small thorn, Icelandic
        "yuml": 255,
        // small y, dieresis or umlaut mark
        // Latin Extended-B
        "fnof": 402,
        // latin small f with hook = function= florin, U+0192 ISOtech
        // Greek
        "Alpha": 913,
        // greek capital letter alpha, U+0391
        "Beta": 914,
        // greek capital letter beta, U+0392
        "Gamma": 915,
        // greek capital letter gamma,U+0393 ISOgrk3
        "Delta": 916,
        // greek capital letter delta,U+0394 ISOgrk3
        "Epsilon": 917,
        // greek capital letter epsilon, U+0395
        "Zeta": 918,
        // greek capital letter zeta, U+0396
        "Eta": 919,
        // greek capital letter eta, U+0397
        "Theta": 920,
        // greek capital letter theta,U+0398 ISOgrk3
        "Iota": 921,
        // greek capital letter iota, U+0399
        "Kappa": 922,
        // greek capital letter kappa, U+039A
        "Lambda": 923,
        // greek capital letter lambda,U+039B ISOgrk3
        "Mu": 924,
        // greek capital letter mu, U+039C
        "Nu": 925,
        // greek capital letter nu, U+039D
        "Xi": 926,
        // greek capital letter xi, U+039E ISOgrk3
        "Omicron": 927,
        // greek capital letter omicron, U+039F
        "Pi": 928,
        // greek capital letter pi, U+03A0 ISOgrk3
        "Rho": 929,
        // greek capital letter rho, U+03A1
        // there is no Sigmaf, and no U+03A2 character either
        "Sigma": 931,
        // greek capital letter sigma,U+03A3 ISOgrk3
        "Tau": 932,
        // greek capital letter tau, U+03A4
        "Upsilon": 933,
        // greek capital letter upsilon,U+03A5 ISOgrk3
        "Phi": 934,
        // greek capital letter phi,U+03A6 ISOgrk3
        "Chi": 935,
        // greek capital letter chi, U+03A7
        "Psi": 936,
        // greek capital letter psi,U+03A8 ISOgrk3
        "Omega": 937,
        // greek capital letter omega,U+03A9 ISOgrk3
        "alpha": 945,
        // greek small letter alpha,U+03B1 ISOgrk3
        "beta": 946,
        // greek small letter beta, U+03B2 ISOgrk3
        "gamma": 947,
        // greek small letter gamma,U+03B3 ISOgrk3
        "delta": 948,
        // greek small letter delta,U+03B4 ISOgrk3
        "epsilon": 949,
        // greek small letter epsilon,U+03B5 ISOgrk3
        "zeta": 950,
        // greek small letter zeta, U+03B6 ISOgrk3
        "eta": 951,
        // greek small letter eta, U+03B7 ISOgrk3
        "theta": 952,
        // greek small letter theta,U+03B8 ISOgrk3
        "iota": 953,
        // greek small letter iota, U+03B9 ISOgrk3
        "kappa": 954,
        // greek small letter kappa,U+03BA ISOgrk3
        "lambda": 955,
        // greek small letter lambda,U+03BB ISOgrk3
        "mu": 956,
        // greek small letter mu, U+03BC ISOgrk3
        "nu": 957,
        // greek small letter nu, U+03BD ISOgrk3
        "xi": 958,
        // greek small letter xi, U+03BE ISOgrk3
        "omicron": 959,
        // greek small letter omicron, U+03BF NEW
        "pi": 960,
        // greek small letter pi, U+03C0 ISOgrk3
        "rho": 961,
        // greek small letter rho, U+03C1 ISOgrk3
        "sigmaf": 962,
        // greek small letter final sigma,U+03C2 ISOgrk3
        "sigma": 963,
        // greek small letter sigma,U+03C3 ISOgrk3
        "tau": 964,
        // greek small letter tau, U+03C4 ISOgrk3
        "upsilon": 965,
        // greek small letter upsilon,U+03C5 ISOgrk3
        "phi": 966,
        // greek small letter phi, U+03C6 ISOgrk3
        "chi": 967,
        // greek small letter chi, U+03C7 ISOgrk3
        "psi": 968,
        // greek small letter psi, U+03C8 ISOgrk3
        "omega": 969,
        // greek small letter omega,U+03C9 ISOgrk3
        "thetasym": 977,
        // greek small letter theta symbol,U+03D1 NEW
        "upsih": 978,
        // greek upsilon with hook symbol,U+03D2 NEW
        "piv": 982,
        // greek pi symbol, U+03D6 ISOgrk3
        // General Punctuation
        "bull": 8226,
        // bullet = black small circle,U+2022 ISOpub
        // bullet is NOT the same as bullet operator, U+2219
        "hellip": 8230,
        // horizontal ellipsis = three dot leader,U+2026 ISOpub
        "prime": 8242,
        // prime = minutes = feet, U+2032 ISOtech
        "Prime": 8243,
        // double prime = seconds = inches,U+2033 ISOtech
        "oline": 8254,
        // overline = spacing overscore,U+203E NEW
        "frasl": 8260,
        // fraction slash, U+2044 NEW
        // Letterlike Symbols
        "weierp": 8472,
        // script capital P = power set= Weierstrass p, U+2118 ISOamso
        "image": 8465,
        // blackletter capital I = imaginary part,U+2111 ISOamso
        "real": 8476,
        // blackletter capital R = real part symbol,U+211C ISOamso
        "trade": 8482,
        // trade mark sign, U+2122 ISOnum
        "alefsym": 8501,
        // alef symbol = first transfinite cardinal,U+2135 NEW
        // alef symbol is NOT the same as hebrew letter alef,U+05D0 although the same glyph could be used to depict both characters
        // Arrows
        "larr": 8592,
        // leftwards arrow, U+2190 ISOnum
        "uarr": 8593,
        // upwards arrow, U+2191 ISOnum-->
        "rarr": 8594,
        // rightwards arrow, U+2192 ISOnum
        "darr": 8595,
        // downwards arrow, U+2193 ISOnum
        "harr": 8596,
        // left right arrow, U+2194 ISOamsa
        "crarr": 8629,
        // downwards arrow with corner leftwards= carriage return, U+21B5 NEW
        "lArr": 8656,
        // leftwards double arrow, U+21D0 ISOtech
        // ISO 10646 does not say that lArr is the same as the 'is implied by' arrow but also does not have any other character for that function. So ? lArr can be used for 'is implied by' as ISOtech suggests
        "uArr": 8657,
        // upwards double arrow, U+21D1 ISOamsa
        "rArr": 8658,
        // rightwards double arrow,U+21D2 ISOtech
        // ISO 10646 does not say this is the 'implies' character but does not have another character with this function so ?rArr can be used for 'implies' as ISOtech suggests
        "dArr": 8659,
        // downwards double arrow, U+21D3 ISOamsa
        "hArr": 8660,
        // left right double arrow,U+21D4 ISOamsa
        // Mathematical Operators
        "forall": 8704,
        // for all, U+2200 ISOtech
        "part": 8706,
        // partial differential, U+2202 ISOtech
        "exist": 8707,
        // there exists, U+2203 ISOtech
        "empty": 8709,
        // empty set = null set = diameter,U+2205 ISOamso
        "nabla": 8711,
        // nabla = backward difference,U+2207 ISOtech
        "isin": 8712,
        // element of, U+2208 ISOtech
        "notin": 8713,
        // not an element of, U+2209 ISOtech
        "ni": 8715,
        // contains as member, U+220B ISOtech
        // should there be a more memorable name than 'ni'?
        "prod": 8719,
        // n-ary product = product sign,U+220F ISOamsb
        // prod is NOT the same character as U+03A0 'greek capital letter pi' though the same glyph might be used for both
        "sum": 8721,
        // n-ary summation, U+2211 ISOamsb
        // sum is NOT the same character as U+03A3 'greek capital letter sigma' though the same glyph might be used for both
        "minus": 8722,
        // minus sign, U+2212 ISOtech
        "lowast": 8727,
        // asterisk operator, U+2217 ISOtech
        "radic": 8730,
        // square root = radical sign,U+221A ISOtech
        "prop": 8733,
        // proportional to, U+221D ISOtech
        "infin": 8734,
        // infinity, U+221E ISOtech
        "ang": 8736,
        // angle, U+2220 ISOamso
        "and": 8743,
        // logical and = wedge, U+2227 ISOtech
        "or": 8744,
        // logical or = vee, U+2228 ISOtech
        "cap": 8745,
        // intersection = cap, U+2229 ISOtech
        "cup": 8746,
        // union = cup, U+222A ISOtech
        "int": 8747,
        // integral, U+222B ISOtech
        "there4": 8756,
        // therefore, U+2234 ISOtech
        "sim": 8764,
        // tilde operator = varies with = similar to,U+223C ISOtech
        // tilde operator is NOT the same character as the tilde, U+007E,although the same glyph might be used to represent both
        "cong": 8773,
        // approximately equal to, U+2245 ISOtech
        "asymp": 8776,
        // almost equal to = asymptotic to,U+2248 ISOamsr
        "ne": 8800,
        // not equal to, U+2260 ISOtech
        "equiv": 8801,
        // identical to, U+2261 ISOtech
        "le": 8804,
        // less-than or equal to, U+2264 ISOtech
        "ge": 8805,
        // greater-than or equal to,U+2265 ISOtech
        "sub": 8834,
        // subset of, U+2282 ISOtech
        "sup": 8835,
        // superset of, U+2283 ISOtech
        // note that nsup, 'not a superset of, U+2283' is not covered by the Symbol font encoding and is not included. Should it be, for symmetry?It is in ISOamsn  --> <!ENTITY nsub": 8836,  //not a subset of, U+2284 ISOamsn
        "sube": 8838,
        // subset of or equal to, U+2286 ISOtech
        "supe": 8839,
        // superset of or equal to,U+2287 ISOtech
        "oplus": 8853,
        // circled plus = direct sum,U+2295 ISOamsb
        "otimes": 8855,
        // circled times = vector product,U+2297 ISOamsb
        "perp": 8869,
        // up tack = orthogonal to = perpendicular,U+22A5 ISOtech
        "sdot": 8901,
        // dot operator, U+22C5 ISOamsb
        // dot operator is NOT the same character as U+00B7 middle dot
        // Miscellaneous Technical
        "lceil": 8968,
        // left ceiling = apl upstile,U+2308 ISOamsc
        "rceil": 8969,
        // right ceiling, U+2309 ISOamsc
        "lfloor": 8970,
        // left floor = apl downstile,U+230A ISOamsc
        "rfloor": 8971,
        // right floor, U+230B ISOamsc
        "lang": 9001,
        // left-pointing angle bracket = bra,U+2329 ISOtech
        // lang is NOT the same character as U+003C 'less than' or U+2039 'single left-pointing angle quotation mark'
        "rang": 9002,
        // right-pointing angle bracket = ket,U+232A ISOtech
        // rang is NOT the same character as U+003E 'greater than' or U+203A 'single right-pointing angle quotation mark'
        // Geometric Shapes
        "loz": 9674,
        // lozenge, U+25CA ISOpub
        // Miscellaneous Symbols
        "spades": 9824,
        // black spade suit, U+2660 ISOpub
        // black here seems to mean filled as opposed to hollow
        "clubs": 9827,
        // black club suit = shamrock,U+2663 ISOpub
        "hearts": 9829,
        // black heart suit = valentine,U+2665 ISOpub
        "diams": 9830,
        // black diamond suit, U+2666 ISOpub
        // Latin Extended-A
        "OElig": 338,
        //  -- latin capital ligature OE,U+0152 ISOlat2
        "oelig": 339,
        //  -- latin small ligature oe, U+0153 ISOlat2
        // ligature is a misnomer, this is a separate character in some languages
        "Scaron": 352,
        //  -- latin capital letter S with caron,U+0160 ISOlat2
        "scaron": 353,
        //  -- latin small letter s with caron,U+0161 ISOlat2
        "Yuml": 376,
        //  -- latin capital letter Y with diaeresis,U+0178 ISOlat2
        // Spacing Modifier Letters
        "circ": 710,
        //  -- modifier letter circumflex accent,U+02C6 ISOpub
        "tilde": 732,
        // small tilde, U+02DC ISOdia
        // General Punctuation
        "ensp": 8194,
        // en space, U+2002 ISOpub
        "emsp": 8195,
        // em space, U+2003 ISOpub
        "thinsp": 8201,
        // thin space, U+2009 ISOpub
        "zwnj": 8204,
        // zero width non-joiner,U+200C NEW RFC 2070
        "zwj": 8205,
        // zero width joiner, U+200D NEW RFC 2070
        "lrm": 8206,
        // left-to-right mark, U+200E NEW RFC 2070
        "rlm": 8207,
        // right-to-left mark, U+200F NEW RFC 2070
        "ndash": 8211,
        // en dash, U+2013 ISOpub
        "mdash": 8212,
        // em dash, U+2014 ISOpub
        "lsquo": 8216,
        // left single quotation mark,U+2018 ISOnum
        "rsquo": 8217,
        // right single quotation mark,U+2019 ISOnum
        "sbquo": 8218,
        // single low-9 quotation mark, U+201A NEW
        "ldquo": 8220,
        // left double quotation mark,U+201C ISOnum
        "rdquo": 8221,
        // right double quotation mark,U+201D ISOnum
        "bdquo": 8222,
        // double low-9 quotation mark, U+201E NEW
        "dagger": 8224,
        // dagger, U+2020 ISOpub
        "Dagger": 8225,
        // double dagger, U+2021 ISOpub
        "permil": 8240,
        // per mille sign, U+2030 ISOtech
        "lsaquo": 8249,
        // single left-pointing angle quotation mark,U+2039 ISO proposed
        // lsaquo is proposed but not yet ISO standardized
        "rsaquo": 8250,
        // single right-pointing angle quotation mark,U+203A ISO proposed
        // rsaquo is proposed but not yet ISO standardized
        "euro": 8364 //  -- euro sign, U+20AC NEW

      },

      /**
       * Escapes the characters in a <code>String</code> using HTML entities.
       *
       * For example: <tt>"bread" & "butter"</tt> => <tt>&amp;quot;bread&amp;quot; &amp;amp; &amp;quot;butter&amp;quot;</tt>.
       * Supports all known HTML 4.0 entities, including funky accents.
       *
       * * <a href="http://www.w3.org/TR/REC-html32#latin1">HTML 3.2 Character Entities for ISO Latin-1</a>
       * * <a href="http://www.w3.org/TR/REC-html40/sgml/entities.html">HTML 4.0 Character entity references</a>
       * * <a href="http://www.w3.org/TR/html401/charset.html#h-5.3">HTML 4.01 Character References</a>
       * * <a href="http://www.w3.org/TR/html401/charset.html#code-position">HTML 4.01 Code positions</a>
       *
       * @param str {String} the String to escape
       * @return {String} a new escaped String
       * @see #unescape
       */
      escape: function escape(str) {
        return qx.util.StringEscape.escape(str, qx.bom.String.FROM_CHARCODE);
      },

      /**
       * Unescapes a string containing entity escapes to a string
       * containing the actual Unicode characters corresponding to the
       * escapes. Supports HTML 4.0 entities.
       *
       * For example, the string "&amp;lt;Fran&amp;ccedil;ais&amp;gt;"
       * will become "&lt;Fran&ccedil;ais&gt;"
       *
       * If an entity is unrecognized, it is left alone, and inserted
       * verbatim into the result string. e.g. "&amp;gt;&amp;zzzz;x" will
       * become "&gt;&amp;zzzz;x".
       *
       * @param str {String} the String to unescape, may be null
       * @return {var} a new unescaped String
       * @see #escape
       */
      unescape: function unescape(str) {
        return qx.util.StringEscape.unescape(str, qx.bom.String.TO_CHARCODE);
      },

      /**
       * Converts a plain text string into HTML.
       * This is similar to {@link #escape} but converts new lines to
       * <tt>&lt:br&gt:</tt> and preserves whitespaces.
       *
       * @param str {String} the String to convert
       * @return {String} a new converted String
       * @see #escape
       */
      fromText: function fromText(str) {
        return qx.bom.String.escape(str).replace(/(  |\n)/g, function (chr) {
          var map = {
            "  ": " &nbsp;",
            "\n": "<br>"
          };
          return map[chr] || chr;
        });
      },

      /**
       * Converts HTML to plain text.
       *
       * * Strips all HTML tags
       * * converts <tt>&lt:br&gt:</tt> to new line
       * * unescapes HTML entities
       *
       * @param str {String} HTML string to converts
       * @return {String} plain text representation of the HTML string
       */
      toText: function toText(str) {
        return qx.bom.String.unescape(str.replace(/\s+|<([^>])+>/gi, function (chr) //return qx.bom.String.unescape(str.replace(/<\/?[^>]+(>|$)/gi, function(chr)
        {
          if (chr.indexOf("<br") === 0) {
            return "\n";
          } else if (chr.length > 0 && chr.replace(/^\s*/, "").replace(/\s*$/, "") == "") {
            return " ";
          } else {
            return "";
          }
        }));
      }
    },

    /*
    *****************************************************************************
       DEFER
    *****************************************************************************
    */
    defer: function defer(statics) {
      /** Mapping of char codes to HTML entity names */
      statics.FROM_CHARCODE = qx.lang.Object.invert(statics.TO_CHARCODE);
    }
  });
  qx.bom.String.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.core.Object": {
        "construct": true,
        "require": true
      },
      "qx.util.format.IFormat": {
        "require": true
      },
      "qx.core.IDisposable": {
        "require": true
      },
      "qx.lang.Type": {
        "construct": true
      },
      "qx.locale.Manager": {
        "construct": true
      },
      "qx.locale.Number": {},
      "qx.lang.String": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2006 STZ-IDA, Germany, http://www.stz-ida.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Til Schneider (til132)
  
  ************************************************************************ */

  /**
   * A formatter and parser for numbers.
   * 
   * NOTE: Instances of this class must be disposed of after use
   *
   */
  qx.Class.define("qx.util.format.NumberFormat", {
    extend: qx.core.Object,
    implement: [qx.util.format.IFormat, qx.core.IDisposable],

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param locale {String} optional locale to be used
     * @throws {Error} If the argument is not a string.
     */
    construct: function construct(locale) {
      qx.core.Object.constructor.call(this);

      if (arguments.length > 0) {
        if (arguments.length === 1) {
          if (qx.lang.Type.isString(locale)) {
            this.setLocale(locale);
          } else {
            throw new Error("Wrong argument type. String is expected.");
          }
        } else {
          throw new Error("Wrong number of arguments.");
        }
      }

      if (!locale) {
        this.setLocale(qx.locale.Manager.getInstance().getLocale());
        {
          qx.locale.Manager.getInstance().bind("locale", this, "locale");
        }
      }
    },

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      /**
       * The minimum number of integer digits (digits before the decimal separator).
       * Missing digits will be filled up with 0 ("19" -> "0019").
       */
      minimumIntegerDigits: {
        check: "Number",
        init: 0
      },

      /**
       * The maximum number of integer digits (superfluous digits will be cut off
       * ("1923" -> "23").
       */
      maximumIntegerDigits: {
        check: "Number",
        nullable: true
      },

      /**
       * The minimum number of fraction digits (digits after the decimal separator).
       * Missing digits will be filled up with 0 ("1.5" -> "1.500")
       */
      minimumFractionDigits: {
        check: "Number",
        init: 0
      },

      /**
       * The maximum number of fraction digits (digits after the decimal separator).
       * Superfluous digits will cause rounding ("1.8277" -> "1.83")
       */
      maximumFractionDigits: {
        check: "Number",
        nullable: true
      },

      /** Whether thousand groupings should be used {e.g. "1,432,234.65"}. */
      groupingUsed: {
        check: "Boolean",
        init: true
      },

      /** The prefix to put before the number {"EUR " -> "EUR 12.31"}. */
      prefix: {
        check: "String",
        init: "",
        event: "changeNumberFormat"
      },

      /** Sets the postfix to put after the number {" %" -> "56.13 %"}. */
      postfix: {
        check: "String",
        init: "",
        event: "changeNumberFormat"
      },

      /** Locale used */
      locale: {
        check: "String",
        init: null,
        event: "changeLocale"
      }
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      /**
       * Formats a number.
       *
       * @param num {Number} the number to format.
       * @return {String} the formatted number as a string.
       */
      format: function format(num) {
        // handle special cases
        if (isNaN(num)) {
          return "NaN";
        }

        switch (num) {
          case Infinity:
            return "Infinity";

          case -Infinity:
            return "-Infinity";
        }

        var negative = num < 0;

        if (negative) {
          num = -num;
        }

        if (this.getMaximumFractionDigits() != null) {
          // Do the rounding
          var mover = Math.pow(10, this.getMaximumFractionDigits());
          num = Math.round(num * mover) / mover;
        }

        var integerDigits = String(Math.floor(num)).length;
        var numStr = "" + num; // Prepare the integer part

        var integerStr = numStr.substring(0, integerDigits);

        while (integerStr.length < this.getMinimumIntegerDigits()) {
          integerStr = "0" + integerStr;
        }

        if (this.getMaximumIntegerDigits() != null && integerStr.length > this.getMaximumIntegerDigits()) {
          // NOTE: We cut off even though we did rounding before, because there
          //     may be rounding errors ("12.24000000000001" -> "12.24")
          integerStr = integerStr.substring(integerStr.length - this.getMaximumIntegerDigits());
        } // Prepare the fraction part


        var fractionStr = numStr.substring(integerDigits + 1);

        while (fractionStr.length < this.getMinimumFractionDigits()) {
          fractionStr += "0";
        }

        if (this.getMaximumFractionDigits() != null && fractionStr.length > this.getMaximumFractionDigits()) {
          // We have already rounded -> Just cut off the rest
          fractionStr = fractionStr.substring(0, this.getMaximumFractionDigits());
        } // Add the thousand groupings


        if (this.getGroupingUsed()) {
          var origIntegerStr = integerStr;
          integerStr = "";
          var groupPos;

          for (groupPos = origIntegerStr.length; groupPos > 3; groupPos -= 3) {
            integerStr = "" + qx.locale.Number.getGroupSeparator(this.getLocale()) + origIntegerStr.substring(groupPos - 3, groupPos) + integerStr;
          }

          integerStr = origIntegerStr.substring(0, groupPos) + integerStr;
        } // Workaround: prefix and postfix are null even their defaultValue is "" and
        //             allowNull is set to false?!?


        var prefix = this.getPrefix() ? this.getPrefix() : "";
        var postfix = this.getPostfix() ? this.getPostfix() : ""; // Assemble the number

        var str = prefix + (negative ? "-" : "") + integerStr;

        if (fractionStr.length > 0) {
          str += "" + qx.locale.Number.getDecimalSeparator(this.getLocale()) + fractionStr;
        }

        str += postfix;
        return str;
      },

      /**
       * Parses a number.
       *
       * @param str {String} the string to parse.
       * @return {Double} the number.
       * @throws {Error} If the number string does not match the number format.
       */
      parse: function parse(str) {
        // use the escaped separators for regexp
        var groupSepEsc = qx.lang.String.escapeRegexpChars(qx.locale.Number.getGroupSeparator(this.getLocale()) + "");
        var decimalSepEsc = qx.lang.String.escapeRegexpChars(qx.locale.Number.getDecimalSeparator(this.getLocale()) + "");
        var regex = new RegExp("^(" + qx.lang.String.escapeRegexpChars(this.getPrefix()) + ')?([-+]){0,1}' + '([0-9]{1,3}(?:' + groupSepEsc + '{0,1}[0-9]{3}){0,}){0,1}' + '(' + decimalSepEsc + '\\d+){0,1}(' + qx.lang.String.escapeRegexpChars(this.getPostfix()) + ")?$");
        var hit = regex.exec(str);

        if (hit == null) {
          throw new Error("Number string '" + str + "' does not match the number format");
        } // hit[1] = potential prefix


        var negative = hit[2] == "-";
        var integerStr = hit[3] || "0";
        var fractionStr = hit[4]; // hit[5] = potential postfix
        // Remove the thousand groupings

        integerStr = integerStr.replace(new RegExp(groupSepEsc, "g"), "");
        var asStr = (negative ? "-" : "") + integerStr;

        if (fractionStr != null && fractionStr.length != 0) {
          // Remove the leading decimal separator from the fractions string
          fractionStr = fractionStr.replace(new RegExp(decimalSepEsc), "");
          asStr += "." + fractionStr;
        }

        return parseFloat(asStr);
      }
    },
    destruct: function destruct() {
      {
        qx.locale.Manager.getInstance().removeRelatedBindings(this);
      }
    }
  });
  qx.util.format.NumberFormat.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.container.Composite": {
        "construct": true,
        "require": true
      },
      "qx.ui.layout.Grow": {
        "construct": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * Clipping area for the table header and table pane.
   */
  qx.Class.define("qx.ui.table.pane.Clipper", {
    extend: qx.ui.container.Composite,
    construct: function construct() {
      qx.ui.container.Composite.constructor.call(this, new qx.ui.layout.Grow());
      this.setMinWidth(0);
    },
    members: {
      /**
       * Scrolls the element's content to the given left coordinate
       *
       * @param value {Integer} The vertical position to scroll to.
       */
      scrollToX: function scrollToX(value) {
        this.getContentElement().scrollToX(value, false);
      },

      /**
       * Scrolls the element's content to the given top coordinate
       *
       * @param value {Integer} The horizontal position to scroll to.
       */
      scrollToY: function scrollToY(value) {
        this.getContentElement().scrollToY(value, true);
      }
    }
  });
  qx.ui.table.pane.Clipper.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.event.type.Pointer": {
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * David Perez Carmona (david-perez)
  
  ************************************************************************ */

  /**
   * A cell event instance contains all data for pointer events related to cells in
   * a table.
   **/
  qx.Class.define("qx.ui.table.pane.CellEvent", {
    extend: qx.event.type.Pointer,

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      /** The table row of the event target */
      row: {
        check: "Integer",
        nullable: true
      },

      /** The table column of the event target */
      column: {
        check: "Integer",
        nullable: true
      }
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      /*
       *****************************************************************************
          CONSTRUCTOR
       *****************************************************************************
       */

      /**
       * Initialize the event
       *
       * @param scroller {qx.ui.table.pane.Scroller} The tables pane scroller
       * @param me {qx.event.type.Pointer} The original pointer event
       * @param row {Integer?null} The cell's row index
       * @param column {Integer?null} The cell's column index
       */
      init: function init(scroller, me, row, column) {
        me.clone(this);
        this.setBubbles(false);

        if (row != null) {
          this.setRow(row);
        } else {
          this.setRow(scroller._getRowForPagePos(this.getDocumentLeft(), this.getDocumentTop()));
        }

        if (column != null) {
          this.setColumn(column);
        } else {
          this.setColumn(scroller._getColumnForPageX(this.getDocumentLeft()));
        }
      },
      // overridden
      clone: function clone(embryo) {
        var clone = qx.ui.table.pane.CellEvent.prototype.clone.base.call(this, embryo);
        clone.set({
          row: this.getRow(),
          column: this.getColumn()
        });
        return clone;
      }
    }
  });
  qx.ui.table.pane.CellEvent.$$dbClassInfo = $$dbClassInfo;
})();
//# sourceMappingURL=package-37.js.map?dt=1635083953826
qx.$$packageData['37'] = {
  "locales": {},
  "resources": {},
  "translations": {}
};

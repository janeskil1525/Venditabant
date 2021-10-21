(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.form.Button": {
        "construct": true,
        "require": true
      },
      "qx.ui.toolbar.PartContainer": {},
      "qx.ui.core.queue.Appearance": {}
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
  
  ************************************************************************ */

  /**
   * The normal toolbar button. Like a normal {@link qx.ui.form.Button}
   * but with a style matching the toolbar and without keyboard support.
   */
  qx.Class.define("qx.ui.toolbar.Button", {
    extend: qx.ui.form.Button,

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */
    construct: function construct(label, icon, command) {
      qx.ui.form.Button.constructor.call(this, label, icon, command); // Toolbar buttons should not support the keyboard events

      this.removeListener("keydown", this._onKeyDown);
      this.removeListener("keyup", this._onKeyUp);
    },

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      appearance: {
        refine: true,
        init: "toolbar-button"
      },
      show: {
        refine: true,
        init: "inherit"
      },
      focusable: {
        refine: true,
        init: false
      }
    },
    members: {
      // overridden
      _applyVisibility: function _applyVisibility(value, old) {
        qx.ui.toolbar.Button.prototype._applyVisibility.base.call(this, value, old); // trigger a appearance recalculation of the parent


        var parent = this.getLayoutParent();

        if (parent && parent instanceof qx.ui.toolbar.PartContainer) {
          qx.ui.core.queue.Appearance.add(parent);
        }
      }
    }
  });
  qx.ui.toolbar.Button.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Bootstrap": {
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
       2004-2008 1&1 Internet AG, Germany, http://www.1und1.de
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * Generic escaping and unescaping of DOM strings.
   *
   * {@link qx.bom.String} for (un)escaping of HTML strings.
   * {@link qx.xml.String} for (un)escaping of XML strings.
   */
  qx.Bootstrap.define("qx.util.StringEscape", {
    statics: {
      /**
       * generic escaping method
       *
       * @param str {String} string to escape
       * @param charCodeToEntities {Map} entity to charcode map
       * @return {String} escaped string
       */
      escape: function escape(str, charCodeToEntities) {
        var entity,
            result = "";

        for (var i = 0, l = str.length; i < l; i++) {
          var chr = str.charAt(i);
          var code = str.codePointAt(i);
          i += String.fromCodePoint(code).length - 1;

          if (charCodeToEntities[code]) {
            entity = "&" + charCodeToEntities[code] + ";";
          } else {
            if (code > 0x7F) {
              entity = "&#" + code + ";";
            } else {
              entity = chr;
            }
          }

          result += entity;
        }

        return result;
      },

      /**
       * generic unescaping method
       *
       * @param str {String} string to unescape
       * @param entitiesToCharCode {Map} charcode to entity map
       * @return {String} unescaped string
       */
      unescape: function unescape(str, entitiesToCharCode) {
        return str.replace(/&[#\w]+;/gi, function (entity) {
          var chr = entity;
          var entity = entity.substring(1, entity.length - 1);
          var code = entitiesToCharCode[entity];

          if (code) {
            chr = String.fromCharCode(code);
          } else {
            if (entity.charAt(0) == '#') {
              if (entity.charAt(1).toUpperCase() == 'X') {
                code = entity.substring(2); // match hex number

                if (code.match(/^[0-9A-Fa-f]+$/gi)) {
                  chr = String.fromCodePoint(parseInt(code, 16));
                }
              } else {
                code = entity.substring(1); // match integer

                if (code.match(/^\d+$/gi)) {
                  chr = String.fromCodePoint(parseInt(code, 10));
                }
              }
            }
          }

          return chr;
        });
      }
    }
  });
  qx.util.StringEscape.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.locale.Manager": {}
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
       * Fabian Jakobs (fjakobs)
  
  ************************************************************************ */

  /**
   * Provides information about locale-dependent number formatting (like the decimal
   * separator).
   *
   * @cldr()
   */
  qx.Class.define("qx.locale.Number", {
    statics: {
      /**
       * Get decimal separator for number formatting
       *
       * @param locale {String} optional locale to be used
       * @return {String} decimal separator.
       */
      getDecimalSeparator: function getDecimalSeparator(locale) {
        return qx.locale.Manager.getInstance().localize("cldr_number_decimal_separator", [], locale);
      },

      /**
       * Get thousand grouping separator for number formatting
       *
       * @param locale {String} optional locale to be used
       * @return {String} group separator.
       */
      getGroupSeparator: function getGroupSeparator(locale) {
        return qx.locale.Manager.getInstance().localize("cldr_number_group_separator", [], locale);
      },

      /**
       * Get percent format string
       *
       * @param locale {String} optional locale to be used
       * @return {String} percent format string.
       */
      getPercentFormat: function getPercentFormat(locale) {
        return qx.locale.Manager.getInstance().localize("cldr_number_percent_format", [], locale);
      }
    }
  });
  qx.locale.Number.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.core.Environment": {
        "defer": "load",
        "usage": "dynamic",
        "require": true
      },
      "qx.Theme": {
        "usage": "dynamic",
        "require": true
      },
      "qx.bom.client.Css": {
        "require": true
      }
    },
    "environment": {
      "provided": [],
      "required": {
        "css.rgba": {
          "load": true,
          "className": "qx.bom.client.Css"
        }
      }
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
  
     Authors:
       * Martin Wittemann (martinwittemann)
       * Tristan Koch (trkoch)
  
  ************************************************************************ */

  /**
   * Indigo color theme
   */
  qx.Theme.define("qx.theme.indigo.Color", {
    colors: {
      // main
      "background": "white",
      "dark-blue": "#323335",
      "light-background": "#F4F4F4",
      "font": "#262626",
      "highlight": "#3D72C9",
      // bright blue
      "highlight-shade": "#5583D0",
      // bright blue
      // backgrounds
      "background-selected": "#3D72C9",
      "background-selected-disabled": "#CDCDCD",
      "background-selected-dark": "#323335",
      "background-disabled": "#F7F7F7",
      "background-disabled-checked": "#BBBBBB",
      "background-pane": "white",
      // tabview
      "tabview-unselected": "#1866B5",
      "tabview-button-border": "#134983",
      "tabview-label-active-disabled": "#D9D9D9",
      // text colors
      "link": "#24B",
      // scrollbar
      "scrollbar-bright": "#F1F1F1",
      "scrollbar-dark": "#EBEBEB",
      // form
      "button": "#E8F0E3",
      "button-border": "#BBB",
      "button-border-hovered": "#939393",
      "invalid": "#C00F00",
      "button-box-bright": "#F9F9F9",
      "button-box-dark": "#E3E3E3",
      "button-box-bright-pressed": "#BABABA",
      "button-box-dark-pressed": "#EBEBEB",
      "border-lead": "#888888",
      // window
      "window-border": "#dddddd",
      "window-border-inner": "#F4F4F4",
      // group box
      "white-box-border": "#dddddd",
      // shadows
      "shadow": qx.core.Environment.get("css.rgba") ? "rgba(0, 0, 0, 0.4)" : "#666666",
      // borders
      "border-main": "#dddddd",
      "border-light": "#B7B7B7",
      "border-light-shadow": "#686868",
      // separator
      "border-separator": "#808080",
      // text
      "text": "#262626",
      "text-disabled": "#A7A6AA",
      "text-selected": "white",
      "text-placeholder": "#CBC8CD",
      // tooltip
      "tooltip": "#FE0",
      "tooltip-text": "black",
      // table
      "table-header": [242, 242, 242],
      "table-focus-indicator": "#3D72C9",
      // used in table code
      "table-header-cell": [235, 234, 219],
      "table-row-background-focused-selected": "#3D72C9",
      "table-row-background-focused": "#F4F4F4",
      "table-row-background-selected": [51, 94, 168],
      "table-row-background-even": "white",
      "table-row-background-odd": "white",
      "table-row-selected": [255, 255, 255],
      "table-row": [0, 0, 0],
      "table-row-line": "#EEE",
      "table-column-line": "#EEE",
      // used in progressive code
      "progressive-table-header": "#AAAAAA",
      "progressive-table-row-background-even": [250, 248, 243],
      "progressive-table-row-background-odd": [255, 255, 255],
      "progressive-progressbar-background": "gray",
      "progressive-progressbar-indicator-done": "#CCCCCC",
      "progressive-progressbar-indicator-undone": "white",
      "progressive-progressbar-percent-background": "gray",
      "progressive-progressbar-percent-text": "white"
    }
  });
  qx.theme.indigo.Color.$$dbClassInfo = $$dbClassInfo;
})();
//# sourceMappingURL=package-37.js.map?dt=1634813684652
qx.$$packageData['37'] = {
  "locales": {},
  "resources": {},
  "translations": {}
};

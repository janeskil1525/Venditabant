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
      "qx.util.format.NumberFormat": {
        "require": true
      },
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.table.cellrenderer.Default": {
        "construct": true,
        "require": true
      }
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2007 by Tartan Solutions, Inc, http://www.tartansolutions.com
  
     License:
       MIT: https://opensource.org/licenses/MIT
  
     Authors:
       * Dan Hummon
  
  ************************************************************************ */

  /**
   * The conditional cell renderer allows special per cell formatting based on
   * conditions on the cell's value.
   *
   * @require(qx.util.format.NumberFormat)
   */
  qx.Class.define("qx.ui.table.cellrenderer.Conditional", {
    extend: qx.ui.table.cellrenderer.Default,

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param align {String|null}
     *   The default text alignment to format the cell with by default.
     *
     * @param color {String|null}
     *   The default font color to format the cell with by default.
     *
     * @param style {String|null}
     *   The default font style to format the cell with by default.
     *
     * @param weight {String|null}
     *   The default font weight to format the cell with by default.
     */
    construct: function construct(align, color, style, weight) {
      qx.ui.table.cellrenderer.Default.constructor.call(this);
      this.numericAllowed = ["==", "!=", ">", "<", ">=", "<="];
      this.betweenAllowed = ["between", "!between"];
      this.conditions = [];
      this.__defaultTextAlign__P_243_0 = align || "";
      this.__defaultColor__P_243_1 = color || "";
      this.__defaultFontStyle__P_243_2 = style || "";
      this.__defaultFontWeight__P_243_3 = weight || "";
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      __defaultTextAlign__P_243_0: null,
      __defaultColor__P_243_1: null,
      __defaultFontStyle__P_243_2: null,
      __defaultFontWeight__P_243_3: null,

      /**
       * Applies the cell styles to the style map.
       * @param condition {Array} The matched condition
       * @param style {Map} map of already applied styles.
       */
      __applyFormatting__P_243_4: function __applyFormatting__P_243_4(condition, style) {
        if (condition[1] != null) {
          style["text-align"] = condition[1];
        }

        if (condition[2] != null) {
          style["color"] = condition[2];
        }

        if (condition[3] != null) {
          style["font-style"] = condition[3];
        }

        if (condition[4] != null) {
          style["font-weight"] = condition[4];
        }
      },

      /**
       * The addNumericCondition method is used to add a basic numeric condition to
       * the cell renderer.
       *
       * Note: Passing null is different from passing an empty string in the align,
       * color, style and weight arguments. Null will allow pre-existing formatting
       * to pass through, where an empty string will clear it back to the default
       * formatting set in the constructor.
       *
       *
       * @param condition {String} The type of condition. Accepted strings are "==", "!=", ">", "<", ">=",
       *     and "<=".
       * @param value1 {Integer} The value to compare against.
       * @param align {String|null} The text alignment to format the cell with if the condition matches.
       * @param color {String|null} The font color to format the cell with if the condition matches.
       * @param style {String|null} The font style to format the cell with if the condition matches.
       * @param weight {String|null} The font weight to format the cell with if the condition matches.
       * @param target {String|null} The text value of the column to compare against. If this is null,
       *     comparisons will be against the contents of this cell.
       * @throws {Error} If the condition can not be recognized or value is null.
       */
      addNumericCondition: function addNumericCondition(condition, value1, align, color, style, weight, target) {
        var temp = null;

        if (this.numericAllowed.includes(condition)) {
          if (value1 != null) {
            temp = [condition, align, color, style, weight, value1, target];
          }
        }

        if (temp != null) {
          this.conditions.push(temp);
        } else {
          throw new Error("Condition not recognized or value is null!");
        }
      },

      /**
       * The addBetweenCondition method is used to add a between condition to the
       * cell renderer.
       *
       * Note: Passing null is different from passing an empty string in the align,
       * color, style and weight arguments. Null will allow pre-existing formatting
       * to pass through, where an empty string will clear it back to the default
       * formatting set in the constructor.
       *
       *
       * @param condition {String} The type of condition. Accepted strings are "between" and "!between".
       * @param value1 {Integer} The first value to compare against.
       * @param value2 {Integer} The second value to compare against.
       * @param align {String|null} The text alignment to format the cell with if the condition matches.
       * @param color {String|null} The font color to format the cell with if the condition matches.
       * @param style {String|null} The font style to format the cell with if the condition matches.
       * @param weight {String|null} The font weight to format the cell with if the condition matches.
       * @param target {String|null} The text value of the column to compare against. If this is null,
       *     comparisons will be against the contents of this cell.
       * @throws {Error} If the condition can not be recognized or value is null.
       */
      addBetweenCondition: function addBetweenCondition(condition, value1, value2, align, color, style, weight, target) {
        if (this.betweenAllowed.includes(condition)) {
          if (value1 != null && value2 != null) {
            var temp = [condition, align, color, style, weight, value1, value2, target];
          }
        }

        if (temp != null) {
          this.conditions.push(temp);
        } else {
          throw new Error("Condition not recognized or value1/value2 is null!");
        }
      },

      /**
       * The addRegex method is used to add a regular expression condition to the
       * cell renderer.
       *
       * Note: Passing null is different from passing an empty string in the align,
       * color, style and weight arguments. Null will allow pre-existing formatting
       * to pass through, where an empty string will clear it back to the default
       * formatting set in the constructor.
       *
       *
       * @param regex {String} The regular expression to match against.
       * @param align {String|null} The text alignment to format the cell with if the condition matches.
       * @param color {String|null} The font color to format the cell with if the condition matches.
       * @param style {String|null} The font style to format the cell with if the condition matches.
       * @param weight {String|null} The font weight to format the cell with if the condition matches.
       * @param target {String|null} The text value of the column to compare against. If this is null,
       *     comparisons will be against the contents of this cell.
       * @throws {Error} If the regex is null.
       */
      addRegex: function addRegex(regex, align, color, style, weight, target) {
        if (regex != null) {
          var temp = ["regex", align, color, style, weight, regex, target];
        }

        if (temp != null) {
          this.conditions.push(temp);
        } else {
          throw new Error("regex cannot be null!");
        }
      },

      /**
       * Overridden; called whenever the cell updates. The cell will iterate through
       * each available condition and apply formatting for those that
       * match. Multiple conditions can match, but later conditions will override
       * earlier ones. Conditions with null values will stack with other conditions
       * that apply to that value.
       *
       * @param cellInfo {Map} The information about the cell.
       *          See {@link qx.ui.table.cellrenderer.Abstract#createDataCellHtml}.
       * @return {Map}
       */
      _getCellStyle: function _getCellStyle(cellInfo) {
        var tableModel = cellInfo.table.getTableModel();
        var i;
        var cond_test;
        var compareValue;
        var style = {
          "text-align": this.__defaultTextAlign__P_243_0,
          "color": this.__defaultColor__P_243_1,
          "font-style": this.__defaultFontStyle__P_243_2,
          "font-weight": this.__defaultFontWeight__P_243_3
        };

        for (i in this.conditions) {
          cond_test = false;

          if (this.numericAllowed.includes(this.conditions[i][0])) {
            if (this.conditions[i][6] == null) {
              compareValue = cellInfo.value;
            } else {
              compareValue = tableModel.getValueById(this.conditions[i][6], cellInfo.row);
            }

            switch (this.conditions[i][0]) {
              case "==":
                if (compareValue == this.conditions[i][5]) {
                  cond_test = true;
                }

                break;

              case "!=":
                if (compareValue != this.conditions[i][5]) {
                  cond_test = true;
                }

                break;

              case ">":
                if (compareValue > this.conditions[i][5]) {
                  cond_test = true;
                }

                break;

              case "<":
                if (compareValue < this.conditions[i][5]) {
                  cond_test = true;
                }

                break;

              case ">=":
                if (compareValue >= this.conditions[i][5]) {
                  cond_test = true;
                }

                break;

              case "<=":
                if (compareValue <= this.conditions[i][5]) {
                  cond_test = true;
                }

                break;
            }
          } else if (this.betweenAllowed.includes(this.conditions[i][0])) {
            if (this.conditions[i][7] == null) {
              compareValue = cellInfo.value;
            } else {
              compareValue = tableModel.getValueById(this.conditions[i][7], cellInfo.row);
            }

            switch (this.conditions[i][0]) {
              case "between":
                if (compareValue >= this.conditions[i][5] && compareValue <= this.conditions[i][6]) {
                  cond_test = true;
                }

                break;

              case "!between":
                if (compareValue < this.conditions[i][5] || compareValue > this.conditions[i][6]) {
                  cond_test = true;
                }

                break;
            }
          } else if (this.conditions[i][0] == "regex") {
            if (this.conditions[i][6] == null) {
              compareValue = cellInfo.value;
            } else {
              compareValue = tableModel.getValueById(this.conditions[i][6], cellInfo.row);
            }

            var the_pattern = new RegExp(this.conditions[i][5], 'g');
            cond_test = the_pattern.test(compareValue);
          } // Apply formatting, if any.


          if (cond_test == true) {
            this.__applyFormatting__P_243_4(this.conditions[i], style);
          }
        }

        var styleString = [];

        for (var key in style) {
          if (style[key]) {
            styleString.push(key, ":", style[key], ";");
          }
        }

        return styleString.join("");
      }
    },

    /*
    *****************************************************************************
       DESTRUCTOR
    *****************************************************************************
    */
    destruct: function destruct() {
      this.numericAllowed = this.betweenAllowed = this.conditions = null;
    }
  });
  qx.ui.table.cellrenderer.Conditional.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.table.cellrenderer.Conditional": {
        "require": true
      },
      "qx.bom.String": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);

  /* ************************************************************************
  
     qooxdoo - the new era of web development
  
     http://qooxdoo.org
  
     Copyright:
       2007 OpenHex SPRL, http://www.openhex.org
  
     License:
       MIT: https://opensource.org/licenses/MIT
       See the LICENSE file in the project's top-level directory for details.
  
     Authors:
       * Gaetan de Menten (ged)
  
  ************************************************************************ */

  /**
   * Specific data cell renderer for dates.
   */
  qx.Class.define("qx.ui.table.cellrenderer.Date", {
    extend: qx.ui.table.cellrenderer.Conditional,

    /*
    *****************************************************************************
       PROPERTIES
    *****************************************************************************
    */
    properties: {
      /**
       * DateFormat used to format the data.
       */
      dateFormat: {
        check: "qx.util.format.DateFormat",
        init: null,
        nullable: true
      }
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      _getContentHtml: function _getContentHtml(cellInfo) {
        var df = this.getDateFormat();

        if (df) {
          if (cellInfo.value) {
            return qx.bom.String.escape(df.format(cellInfo.value));
          } else {
            return "";
          }
        } else {
          return cellInfo.value || "";
        }
      },
      // overridden
      _getCellClass: function _getCellClass(cellInfo) {
        return "qooxdoo-table-cell";
      }
    }
  });
  qx.ui.table.cellrenderer.Date.$$dbClassInfo = $$dbClassInfo;
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
//# sourceMappingURL=package-37.js.map?dt=1638973476229
qx.$$packageData['37'] = {
  "locales": {},
  "resources": {},
  "translations": {}
};

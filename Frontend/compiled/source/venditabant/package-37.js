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
      "qx.ui.table.cellrenderer.AbstractImage": {
        "construct": true,
        "require": true
      },
      "qx.util.AliasManager": {
        "construct": true
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
   * The image cell renderer renders image into table cells.
   */
  qx.Class.define("qx.ui.table.cellrenderer.Image", {
    extend: qx.ui.table.cellrenderer.AbstractImage,

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param height {Integer?16} The height of the image. The default is 16.
     * @param width {Integer?16} The width of the image. The default is 16.
     */
    construct: function construct(width, height) {
      qx.ui.table.cellrenderer.AbstractImage.constructor.call(this);

      if (width) {
        this.__imageWidth__P_245_0 = width;
      }

      if (height) {
        this.__imageHeight__P_245_1 = height;
      }

      this.__am__P_245_2 = qx.util.AliasManager.getInstance();
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      __am__P_245_2: null,
      __imageHeight__P_245_1: 16,
      __imageWidth__P_245_0: 16,
      // overridden
      _identifyImage: function _identifyImage(cellInfo) {
        var imageHints = {
          imageWidth: this.__imageWidth__P_245_0,
          imageHeight: this.__imageHeight__P_245_1
        };

        if (cellInfo.value == "") {
          imageHints.url = null;
        } else {
          imageHints.url = this.__am__P_245_2.resolve(cellInfo.value);
        }

        imageHints.tooltip = cellInfo.tooltip;
        return imageHints;
      }
    },

    /*
    *****************************************************************************
       DESTRUCTOR
    *****************************************************************************
    */
    destruct: function destruct() {
      this.__am__P_245_2 = null;
    }
  });
  qx.ui.table.cellrenderer.Image.$$dbClassInfo = $$dbClassInfo;
})();

(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "qx.ui.core.scroll.AbstractScrollArea": {
        "construct": true,
        "require": true
      },
      "qx.ui.core.IMultiSelection": {
        "require": true
      },
      "qx.ui.form.IForm": {
        "require": true
      },
      "qx.ui.form.IField": {
        "require": true
      },
      "qx.ui.form.IModelSelection": {
        "require": true
      },
      "qx.ui.core.MRemoteChildrenHandling": {
        "require": true
      },
      "qx.ui.core.MMultiSelectionHandling": {
        "require": true
      },
      "qx.ui.form.MForm": {
        "require": true
      },
      "qx.ui.form.MModelSelection": {
        "require": true
      },
      "qx.ui.core.selection.ScrollArea": {
        "require": true
      },
      "qx.ui.container.Composite": {},
      "qx.ui.layout.HBox": {},
      "qx.ui.layout.VBox": {},
      "qx.bom.element.Attribute": {}
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
       * Martin Wittemann (martinwittemann)
       * Christian Hagendorn (chris_schmidt)
  
  ************************************************************************ */

  /**
   * A list of items. Displays an automatically scrolling list for all
   * added {@link qx.ui.form.ListItem} instances. Supports various
   * selection options: single, multi, ...
   */
  qx.Class.define("qx.ui.form.List", {
    extend: qx.ui.core.scroll.AbstractScrollArea,
    implement: [qx.ui.core.IMultiSelection, qx.ui.form.IForm, qx.ui.form.IField, qx.ui.form.IModelSelection],
    include: [qx.ui.core.MRemoteChildrenHandling, qx.ui.core.MMultiSelectionHandling, qx.ui.form.MForm, qx.ui.form.MModelSelection],

    /*
    *****************************************************************************
       CONSTRUCTOR
    *****************************************************************************
    */

    /**
     * @param horizontal {Boolean?false} Whether the list should be horizontal.
     */
    construct: function construct(horizontal) {
      qx.ui.core.scroll.AbstractScrollArea.constructor.call(this); // Create content

      this.__content__P_218_0 = this._createListItemContainer(); // Used to fire item add/remove events

      this.__content__P_218_0.addListener("addChildWidget", this._onAddChild, this);

      this.__content__P_218_0.addListener("removeChildWidget", this._onRemoveChild, this); // Add to scrollpane


      this.getChildControl("pane").add(this.__content__P_218_0); // Apply orientation

      if (horizontal) {
        this.setOrientation("horizontal");
      } else {
        this.initOrientation();
      } // Add keypress listener


      this.addListener("keypress", this._onKeyPress);
      this.addListener("keyinput", this._onKeyInput); // initialize the search string

      this.__pressedString__P_218_1 = "";
    },

    /*
    *****************************************************************************
       EVENTS
    *****************************************************************************
    */
    events: {
      /**
       * This event is fired after a list item was added to the list. The
       * {@link qx.event.type.Data#getData} method of the event returns the
       * added item.
       */
      addItem: "qx.event.type.Data",

      /**
       * This event is fired after a list item has been removed from the list.
       * The {@link qx.event.type.Data#getData} method of the event returns the
       * removed item.
       */
      removeItem: "qx.event.type.Data"
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
        init: "list"
      },
      // overridden
      focusable: {
        refine: true,
        init: true
      },
      // overridden
      width: {
        refine: true,
        init: 100
      },
      // overridden
      height: {
        refine: true,
        init: 200
      },

      /**
       * Whether the list should be rendered horizontal or vertical.
       */
      orientation: {
        check: ["horizontal", "vertical"],
        init: "vertical",
        apply: "_applyOrientation"
      },

      /** Spacing between the items */
      spacing: {
        check: "Integer",
        init: 0,
        apply: "_applySpacing",
        themeable: true
      },

      /** Controls whether the inline-find feature is activated or not */
      enableInlineFind: {
        check: "Boolean",
        init: true
      },

      /** Whether the list is read only when enabled */
      readOnly: {
        check: "Boolean",
        init: false,
        event: "changeReadOnly",
        apply: "_applyReadOnly"
      }
    },

    /*
    *****************************************************************************
       MEMBERS
    *****************************************************************************
    */
    members: {
      __pressedString__P_218_1: null,
      __lastKeyPress__P_218_2: null,

      /** @type {qx.ui.core.Widget} The children container */
      __content__P_218_0: null,

      /** @type {Class} Pointer to the selection manager to use */
      SELECTION_MANAGER: qx.ui.core.selection.ScrollArea,

      /*
      ---------------------------------------------------------------------------
        WIDGET API
      ---------------------------------------------------------------------------
      */
      // overridden
      getChildrenContainer: function getChildrenContainer() {
        return this.__content__P_218_0;
      },

      /**
       * Handle child widget adds on the content pane
       *
       * @param e {qx.event.type.Data} the event instance
       */
      _onAddChild: function _onAddChild(e) {
        this.fireDataEvent("addItem", e.getData());
      },

      /**
       * Handle child widget removes on the content pane
       *
       * @param e {qx.event.type.Data} the event instance
       */
      _onRemoveChild: function _onRemoveChild(e) {
        this.fireDataEvent("removeItem", e.getData());
      },

      /*
      ---------------------------------------------------------------------------
        PUBLIC API
      ---------------------------------------------------------------------------
      */

      /**
       * Used to route external <code>keypress</code> events to the list
       * handling (in fact the manager of the list)
       *
       * @param e {qx.event.type.KeySequence} KeyPress event
       */
      handleKeyPress: function handleKeyPress(e) {
        if (!this._onKeyPress(e)) {
          this._getManager().handleKeyPress(e);
        }
      },

      /*
      ---------------------------------------------------------------------------
        PROTECTED API
      ---------------------------------------------------------------------------
      */

      /**
       * This container holds the list item widgets.
       *
       * @return {qx.ui.container.Composite} Container for the list item widgets
       */
      _createListItemContainer: function _createListItemContainer() {
        return new qx.ui.container.Composite();
      },

      /*
      ---------------------------------------------------------------------------
        PROPERTY APPLY ROUTINES
      ---------------------------------------------------------------------------
      */
      // property apply
      _applyOrientation: function _applyOrientation(value, old) {
        var content = this.__content__P_218_0; // save old layout for disposal

        var oldLayout = content.getLayout(); // Create new layout

        var horizontal = value === "horizontal";
        var layout = horizontal ? new qx.ui.layout.HBox() : new qx.ui.layout.VBox(); // Configure content

        content.setLayout(layout);
        content.setAllowGrowX(!horizontal);
        content.setAllowGrowY(horizontal); // Configure spacing

        this._applySpacing(this.getSpacing()); // dispose old layout


        if (oldLayout) {
          oldLayout.dispose();
        }
      },
      // property apply
      _applySpacing: function _applySpacing(value, old) {
        this.__content__P_218_0.getLayout().setSpacing(value);
      },
      // property readOnly
      _applyReadOnly: function _applyReadOnly(value) {
        this._getManager().setReadOnly(value);

        if (value) {
          this.addState("readonly");
          this.addState("disabled"); // Remove draggable

          if (this.isDraggable()) {
            this._applyDraggable(false, true);
          } // Remove droppable


          if (this.isDroppable()) {
            this._applyDroppable(false, true);
          }
        } else {
          this.removeState("readonly");

          if (this.isEnabled()) {
            this.removeState("disabled"); // Re-add draggable

            if (this.isDraggable()) {
              this._applyDraggable(true, false);
            } // Re-add droppable


            if (this.isDroppable()) {
              this._applyDroppable(true, false);
            }
          }
        }
      },
      // override
      _applyEnabled: function _applyEnabled(value, old) {
        qx.ui.form.List.prototype._applyEnabled.base.call(this, value, old); // If editable has just been turned on, we need to correct for readOnly status 


        if (value && this.isReadOnly()) {
          this.addState("disabled"); // Remove draggable

          if (this.isDraggable()) {
            this._applyDraggable(false, true);
          } // Remove droppable


          if (this.isDroppable()) {
            this._applyDroppable(false, true);
          }
        }
      },

      /*
      ---------------------------------------------------------------------------
        EVENT HANDLER
      ---------------------------------------------------------------------------
      */

      /**
       * Event listener for <code>keypress</code> events.
       *
       * @param e {qx.event.type.KeySequence} KeyPress event
       * @return {Boolean} Whether the event was processed
       */
      _onKeyPress: function _onKeyPress(e) {
        // Execute action on press <ENTER>
        if (e.getKeyIdentifier() == "Enter" && !e.isAltPressed()) {
          var items = this.getSelection();

          for (var i = 0; i < items.length; i++) {
            items[i].fireEvent("action");
          }

          return true;
        }

        return false;
      },

      /*
      ---------------------------------------------------------------------------
        FIND SUPPORT
      ---------------------------------------------------------------------------
      */

      /**
       * Handles the inline find - if enabled
       *
       * @param e {qx.event.type.KeyInput} key input event
       */
      _onKeyInput: function _onKeyInput(e) {
        // do nothing if the find is disabled
        if (!this.getEnableInlineFind()) {
          return;
        } // Only useful in single or one selection mode


        var mode = this.getSelectionMode();

        if (!(mode === "single" || mode === "one")) {
          return;
        } // Reset string after a second of non pressed key


        if (new Date().valueOf() - this.__lastKeyPress__P_218_2 > 1000) {
          this.__pressedString__P_218_1 = "";
        } // Combine keys the user pressed to a string


        this.__pressedString__P_218_1 += e.getChar(); // Find matching item

        var matchedItem = this.findItemByLabelFuzzy(this.__pressedString__P_218_1); // if an item was found, select it

        if (matchedItem) {
          this.setSelection([matchedItem]);
        } // Store timestamp


        this.__lastKeyPress__P_218_2 = new Date().valueOf();
      },

      /**
       * Takes the given string and tries to find a ListItem
       * which starts with this string. The search is not case sensitive and the
       * first found ListItem will be returned. If there could not be found any
       * qualifying list item, null will be returned.
       *
       * @param search {String} The text with which the label of the ListItem should start with
       * @return {qx.ui.form.ListItem} The found ListItem or null
       */
      findItemByLabelFuzzy: function findItemByLabelFuzzy(search) {
        // lower case search text
        search = search.toLowerCase(); // get all items of the list

        var items = this.getChildren(); // go threw all items

        for (var i = 0, l = items.length; i < l; i++) {
          // get the label of the current item
          var currentLabel = items[i].getLabel(); // if the label fits with the search text (ignore case, begins with)

          if (currentLabel && currentLabel.toLowerCase().indexOf(search) == 0) {
            // just return the first found element
            return items[i];
          }
        } // if no element was found, return null


        return null;
      },

      /**
       * Find an item by its {@link qx.ui.basic.Atom#getLabel}.
       *
       * @param search {String} A label or any item
       * @param ignoreCase {Boolean?true} description
       * @return {qx.ui.form.ListItem} The found ListItem or null
       */
      findItem: function findItem(search, ignoreCase) {
        // lowercase search
        if (ignoreCase !== false) {
          search = search.toLowerCase();
        }

        ; // get all items of the list

        var items = this.getChildren();
        var item; // go through all items

        for (var i = 0, l = items.length; i < l; i++) {
          item = items[i]; // get the content of the label; text content when rich

          var label;

          if (item.isRich()) {
            var control = item.getChildControl("label", true);

            if (control) {
              var labelNode = control.getContentElement().getDomElement();

              if (labelNode) {
                label = qx.bom.element.Attribute.get(labelNode, "text");
              }
            }
          } else {
            label = item.getLabel();
          }

          if (label != null) {
            if (label.translate) {
              label = label.translate();
            }

            if (ignoreCase !== false) {
              label = label.toLowerCase();
            }

            if (label.toString() == search.toString()) {
              return item;
            }
          }
        }

        return null;
      }
    },

    /*
    *****************************************************************************
       DESTRUCTOR
    *****************************************************************************
    */
    destruct: function destruct() {
      this._disposeObjects("__content__P_218_0");
    }
  });
  qx.ui.form.List.$$dbClassInfo = $$dbClassInfo;
})();
//# sourceMappingURL=package-37.js.map?dt=1650902124689
qx.$$packageData['37'] = {
  "locales": {},
  "resources": {},
  "translations": {}
};

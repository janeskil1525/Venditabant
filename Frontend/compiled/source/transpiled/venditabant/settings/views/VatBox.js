(function () {
  var $$dbClassInfo = {
    "dependsOn": {
      "qx.Class": {
        "usage": "dynamic",
        "require": true
      },
      "venditabant.application.base.views.Base": {
        "require": true
      },
      "qx.locale.MTranslation": {
        "require": true
      },
      "qx.ui.groupbox.GroupBox": {},
      "qx.ui.layout.VBox": {},
      "qx.ui.container.Composite": {},
      "qx.ui.layout.HBox": {},
      "qx.ui.form.List": {},
      "qx.ui.form.ListItem": {}
    }
  };
  qx.Bootstrap.executePendingDefers($$dbClassInfo);
  qx.Class.define("venditabant.settings.views.VatBox", {
    extend: venditabant.application.base.views.Base,
    include: [qx.locale.MTranslation],
    construct: function construct() {},
    destruct: function destruct() {},
    properties: {
      support: {
        nullable: true,
        check: "Boolean"
      }
    },
    members: {
      // Public functions ...
      getView: function getView() {
        var box1 = new qx.ui.groupbox.GroupBox(this.tr("VAT"), null);
        box1.setLayout(new qx.ui.layout.VBox());
        var container = new qx.ui.container.Composite(new qx.ui.layout.HBox(6));

        var lbl = this._createLbl(this.tr("Percentage"), 70);

        var vat_txt = this._createTxt(this.tr("VAT"), 60, true, this.tr("VAT is required"));

        this._vat_txt = vat_txt;
        vat_txt.addListener("input", function (e) {
          var value = e.getData();
        }, this);
        container.add(lbl, {
          flex: 1
        });
        container.add(vat_txt);
        box1.add(container);

        var vat_desc = this._createTxt(this.tr("Description"), 120, true, this.tr("VAT is required"));

        this._vat_desc = vat_desc;
        box1.add(vat_desc);

        var save_VAT = this._createBtn(this.tr("Save"), "rgba(239,170,255,0.44)", 120, function () {
          this.saveVAT();
        }, this);

        box1.add(save_VAT);
        var oneList = new qx.ui.form.List();
        oneList.addListener("changeSelection", function (e) {
          var selection = e.getData()[0].getLabel();

          this._vat_txt.setValue(selection);

          this._vat_desc.setValue(selection);
        }, this);
        oneList.set({
          height: 100,
          width: 150,
          selectionMode: "one"
        });
        var item;

        for (var i = 1; i <= 25; i++) {
          item = new qx.ui.form.ListItem("Item No " + i, null);
          oneList.add(item);
        }

        box1.add(oneList);
        return box1;
      }
    }
  });
  venditabant.settings.views.VatBox.$$dbClassInfo = $$dbClassInfo;
})();

//# sourceMappingURL=VatBox.js.map?dt=1633343323171
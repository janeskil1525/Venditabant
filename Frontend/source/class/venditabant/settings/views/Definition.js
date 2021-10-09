
qx.Class.define ( "venditabant.settings.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean" }
        },
        members: {
            // Public functions ...
            getView: function () {
                let that = this;
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "1000%"});

                var page1 = new qx.ui.tabview.Page(this.tr("Sales"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let vat = new venditabant.settings.views.SettingListBox().set({
                    width: 100,
                    height: 200,
                    savebuttonwidth:40,
                    parameter: 'VAT',
                    groupboxheader: this.tr("VAT"),
                    valuelabel: this.tr("Percentage"),
                    valueplaceholder: this.tr("0-9 %"),
                    invalidmessage: this.tr("Percentage is required"),
                    descriptionplaceholder: this.tr("Description"),
                    descriptioninvalidmessage: this.tr("Description is required"),
                    valuefilter: /[0-9\%]/,
                    savebutton: this.tr("Save"),
                    deletebutton: this.tr("Delete"),
                    newbutton: this.tr("New"),
                }).getView();
                page1.add ( vat, { top: 0, left: 10 } );

                let invoicedays = new venditabant.settings.views.SettingListBox().set({
                    width: 100,
                    height: 200,
                    savebuttonwidth:40,
                    parameter: 'INVOICEDAYS',
                    groupboxheader: this.tr("Invoice days"),
                    valuelabel: this.tr("Days"),
                    valueplaceholder: this.tr("Ds"),
                    invalidmessage: this.tr("Days are required"),
                    descriptionplaceholder: this.tr("Description"),
                    descriptioninvalidmessage: this.tr("Description is required"),
                    valuefilter: /[0-9]/,
                    savebutton: this.tr("Save"),
                    deletebutton: this.tr("Delete"),
                    newbutton: this.tr("New"),
                }).getView();
                page1.add ( invoicedays, { top: 0, left: 230 } );
                tabView.add(page1);

                var page2 = new qx.ui.tabview.Page("Stock");
                page2.setLayout(new qx.ui.layout.Canvas());

                let productgroups = new venditabant.settings.views.SettingListBox().set({
                    width: 200,
                    height: 200,
                    savebuttonwidth:40,
                    parameter: 'PRODUCTGROUPS',
                    groupboxheader: this.tr("Product groups"),
                    valuelabel: this.tr("Group"),
                    valueplaceholder: this.tr("Group"),
                    invalidmessage: this.tr("Group is required"),
                    descriptionplaceholder: this.tr("Description"),
                    descriptioninvalidmessage: this.tr("Description is required"),
                    valuefilter: /[0-9]/,
                    savebutton: this.tr("Save"),
                    deletebutton: this.tr("Delete"),
                    newbutton: this.tr("New"),
                }).getView();
                page2.add ( productgroups, { top: 0, left: 10 } );

                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Accounting");
                page3.setLayout(new qx.ui.layout.Canvas());

                let accounts = new venditabant.settings.views.SettingListBox().set({
                    width: 200,
                    height: 200,
                    savebuttonwidth:40,
                    parameter: 'ACCOUNTS',
                    groupboxheader: this.tr("Accounts"),
                    valuelabel: this.tr("Account"),
                    valueplaceholder: this.tr("Account"),
                    invalidmessage: this.tr("Account is required"),
                    descriptionplaceholder: this.tr("Description"),
                    descriptioninvalidmessage: this.tr("Description is required"),
                    valuefilter: /[0-9]/,
                    savebutton: this.tr("Save"),
                    deletebutton: this.tr("Delete"),
                    newbutton: this.tr("New"),
                }).getView();
                page3.add ( accounts, { top: 0, left: 10 } );

                tabView.add(page3);

                var page4 = new qx.ui.tabview.Page("Mails");
                tabView.add(page4);

                return view;
            }
        }
    });

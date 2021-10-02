qx.Class.define ( "venditabant.application.ApplicationWindow",
    {
        extend : qx.ui.window.Window,

        construct : function (  ) {
            this.base ( arguments );
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.setWidth  ( 1000 );
            this.setHeight ( 700 );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 700 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 1000 ) / 2, 10 );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot ( );
            root.add ( this, { top: top, left: left } );

        },
        destruct : function ( )  {
        },
        properties : {
            support : { nullable : true, check: "Boolean", apply:"supportWorks" }
        },
        members  : {
            _support:null,
            // Public functions ...
            setParams: function (params) {
            },
            start: function () {
                // virtual function to kick off exection.
                this.show();
            },
            logout: function () {
                let jwt = new qx.data.store.Offline('userid','local');
                jwt.setModel(qx.data.marshal.Json.createModel({ }));
                let win = new venditabant.users.login.LoginWindow();
                win.show();
                this.destroy();
            },
            _buildWindow: function () {
                var font = new qx.bom.Font(24, ["Arial"]);
                font.setBold(true);
                var scroller = new qx.ui.container.Scroll();

                var container = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                container.setPadding(5);
                container.setAllowStretchX(true);
                container.setBackgroundColor("red");
                scroller.add(container);
                this.add(scroller, {edge: 0});

                var bar = this.getMenuBar();
                container.add(bar, {left: 0, top: 0, right:0});
                this._menubar = bar;

                /* var stack = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                this.add(stack, {left: 5, top: 50, right: 5, height:"86%"});
                stack.setBackgroundColor("green");
                this._stack = stack;
                var app  = qx.core.Init.getApplication ( );
                var root = app.getRoot ( );
                this._stack = stack;*/

                let app  = qx.core.Init.getApplication ( );
                let root = app.getRoot ( );
                root._basewin = this;

                this.cockpitButton();
               /* // name
                var nameLabel = new qx.ui.basic.Label("Name:");
                page1.add(nameLabel, {row: 0, column: 0});
                var name = new qx.ui.form.TextField();
                name.setRequired(true);
                page1.add(name, {row: 0, column: 1});*/

               /* var lbl = new qx.ui.basic.Label(this.tr("Hello World"));
                lbl.setFont(font);
                this.add(lbl, {top: "50%", left: "40%"});*/

                var lbl = new qx.ui.basic.Label(this.tr("Hello World"));
                lbl.setFont(font);
                this.add(lbl, {top: 300, left: 100});

                var btn = new qx.ui.form.Button(this.tr("Logout"));
                btn.setWidth(90);
                btn.addListener("execute", function (e) {
                    this.logout();
                }, this);
                this.add(btn, {bottom: 5, right: 100});
                btn = new qx.ui.form.Button(this.tr("Cancel"));
                btn.setWidth(90);
                btn.addListener("execute", function (e) {
                    alert("Don't close me ... Please ...");
//         this.close ( );
                }, this);
                this.add(btn, {bottom: 5, right: 5});
                this.setStatus("Application is ready");
            },
            cockpitButton:function(){
                var app  = qx.core.Init.getApplication ( );
                var root = app.getRoot ( );
                if(typeof root._basewin._stack !== "undefined" || root._basewin._stack === null){
                    root._basewin._stack.destroy();
                }
                let stack = new venditabant.cockpit.views.Cockpit().getView();
                root._basewin.add(stack, {left: 5, top: 50, right: 5, height:"86%"});

                root._basewin._stack = stack;

            },
            getMenuBar: function () {
                var frame = new qx.ui.container.Composite(new qx.ui.layout.Grow());

                var menubar = new qx.ui.menubar.MenuBar();
                //menubar.setWidth(600);
                frame.add(menubar);

                var homeMenu = new qx.ui.menubar.Button(this.tr("Home"), null, this.getHomeMenu());
                var editMenu = new qx.ui.menubar.Button("Edit", null, this.getEditMenu());
                var adminhMenu = new qx.ui.menubar.Button("Administration", null, this.getAdminMenu());
                let salesMenu = new qx.ui.menubar.Button("Sales", null, this.getSalesMenu());
                let stockMenu = new qx.ui.menubar.Button("Stock", null, this.getStockMenu());

                /* var viewMenu = new qx.ui.menubar.Button("View", null, this.getViewMenu());
                 var formatMenu = new qx.ui.menubar.Button("Format", null, this.getFormatMenu());
                 var helpMenu = new qx.ui.menubar.Button("Help", null, this.getHelpMenu());*/

                menubar.add(homeMenu);
                menubar.add(editMenu);
                menubar.add(adminhMenu);
                menubar.add(salesMenu);
                menubar.add(stockMenu);

                /* menubar.add(viewMenu);
                 menubar.add(formatMenu);
                 menubar.add(helpMenu);*/
                if(this.isSupport() === true) {
                    var supportMenu = new qx.ui.menubar.Button("Support", null, this.getSupportMenu());
                    menubar.add(supportMenu);
                }

                return frame;
            },
            debugRadio: function (e) {
                this.debug("Change selection: " + e.getData()[0].getLabel());
            },

            debugCommand: function (e) {
                this.debug("Execute command: " + this.getShortcut());
            },

            debugButton: function (e) {
                this.debug("Execute button: " + this.getLabel());
            },

            debugCheckBox: function (e) {
                this.debug("Change checked: " + this.getLabel() + " = " + e.getData());
            },
            homeButton:function() {

            },
            getHomeMenu: function () {
                let menu = new qx.ui.menu.Menu();

                let homePageButton = new qx.ui.menu.Button(this.tr("Cockpit"), null);
                let logoutButton = new qx.ui.menu.Button(this.tr("Logout"), null);

                homePageButton.addListener("execute", this.cockpitButton);
                logoutButton.addListener("execute", this.logout);

                menu.add(homePageButton);
                menu.add(logoutButton);

                return menu;
            },
            getNewMenu:function() {
                var menu = new qx.ui.menu.Menu();

                var newStockitem = new qx.ui.menu.Button("New stockitem", null, this._newCommand);
                newStockitem.addListener("execute", this.debugButton);
                menu.add(newStockitem);

                return menu;
            },
            getEditMenu: function () {
                var menu = new qx.ui.menu.Menu();

                var undoButton = new qx.ui.menu.Button("Undo", "icon/16/actions/edit-undo.png", this._undoCommand);
                var redoButton = new qx.ui.menu.Button("Redo", "icon/16/actions/edit-redo.png", this._redoCommand);
                var cutButton = new qx.ui.menu.Button("Cut", "icon/16/actions/edit-cut.png", this._cutCommand);
                var copyButton = new qx.ui.menu.Button("Copy", "icon/16/actions/edit-copy.png", this._copyCommand);
                var pasteButton = new qx.ui.menu.Button("Paste", "icon/16/actions/edit-paste.png", this._pasteCommand);

                undoButton.addListener("execute", this.debugButton);
                redoButton.addListener("execute", this.debugButton);
                cutButton.addListener("execute", this.debugButton);
                copyButton.addListener("execute", this.debugButton);
                pasteButton.addListener("execute", this.debugButton);

                menu.add(undoButton);
                menu.add(redoButton);
                menu.addSeparator();
                menu.add(cutButton);
                menu.add(copyButton);
                menu.add(pasteButton);

                return menu;
            },
            getAdminMenu: function () {
                let that = this;
                let menu = new qx.ui.menu.Menu();

                let usersButton = new qx.ui.menu.Button("Users");
                let stockitemButton = new qx.ui.menu.Button("Stockitems");
                let pricelistButton = new qx.ui.menu.Button("Pricelists");
                let customerButton = new qx.ui.menu.Button("Customers");
                /* var replaceButton = new qx.ui.menu.Button("Replace");
                var searchFilesButton = new qx.ui.menu.Button("Search in files", "icon/16/actions/system-search.png");
                var replaceFilesButton = new qx.ui.menu.Button("Replace in files");*/

                //previousButton.setEnabled(false);

                usersButton.addListener("execute", function() {
                    let userwindow = new venditabant.users.management.views.Definition();
                    let support = that.isSupport();

                    userwindow.set({
                        support:support
                    });
                });
                stockitemButton.addListener("execute", this.stockitemsButton);
                pricelistButton.addListener("execute", this.pricelistButton);
                customerButton.addListener("execute", this.customerButton);
                /* replaceButton.addListener("execute", this.debugButton);
                searchFilesButton.addListener("execute", this.debugButton);
                replaceFilesButton.addListener("execute", this.debugButton);*/


                menu.add(usersButton);
                menu.add(stockitemButton);
                menu.add(pricelistButton);
                menu.add(customerButton);
                /*menu.add(replaceButton);
                menu.addSeparator();
                menu.add(searchFilesButton);
                menu.add(replaceFilesButton);*/

                return menu;
            },
            getSalesMenu:function() {
                let that = this;
                let menu = new qx.ui.menu.Menu();

                let userssalesorderButton = new qx.ui.menu.Button("Salesorders");
                userssalesorderButton.addListener("execute", this.salesordersButton);

                let invoiceButton = new qx.ui.menu.Button("Invoices");
                invoiceButton.addListener("execute", this.invoiceButton);

                menu.add(userssalesorderButton);
                menu.add(invoiceButton);

                return menu;
            },
            getStockMenu:function() {
                let that = this;
                let menu = new qx.ui.menu.Menu();

                let stockButton = new qx.ui.menu.Button("Stock");
                stockButton.addListener("execute", this.stockButton);

                menu.add(stockButton);

                return menu;
            },
            getSupportMenu:function() {
                let menu = new qx.ui.menu.Menu();
                let that = this;
                let usersButton = new qx.ui.menu.Button("Users");
                usersButton.addListener("execute", function() {
                    let userwindow = new venditabant.users.management.views.Definition();
                    let support = that.isSupport();

                    userwindow.set({
                        support:support
                    });
                });
                menu.add(usersButton);

                return menu;
            },
            closeButton:function() {
                var app  = qx.core.Init.getApplication ( );
                var root = app.getRoot ( );
                root._basewin._stack.destroy();

            },
            stockButton:function() {
                var app  = qx.core.Init.getApplication ( );
                var root = app.getRoot ( );
                root._basewin._stack.destroy();
                var stack = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                stack.setBackgroundColor("blue");
                root._basewin.add(stack,{left: 5, top:50, right:5, height:"86%"});
                root._basewin._stack = stack;
            },
            invoiceButton:function() {
                let invoicewindow = new venditabant.sales.invoices.views.Definition();
            },
            salesordersButton:function() {
                let salesorderswindow = new venditabant.sales.orders.views.Definition();
            },
            supportWorks:function(value) {
                this._buildWindow  ( );
            },
            customerButton: function() {
                let customerswindow = new venditabant.sales.customers.views.Definition();
            },
            stockitemsButton: function () {
                let stockitemswindow = new venditabant.stock.stockitems.views.Definition();
            },
            pricelistButton: function() {
                let pricelistwindow = new venditabant.sales.pricelists.views.Definition();
            }
        }
    });

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

                let app  = qx.core.Init.getApplication ( );
                let root = app.getRoot ( );
                root._basewin = this;
                this.cockpitButton();
                this.setStatus("Application is ready");
            },
            cockpitButton:function(){
                let root  = qx.core.Init.getApplication ( ).getRoot();
                let view = new venditabant.cockpit.views.Cockpit().getView();
                root._basewin.addView(root, view);
            },
            addView:function(root, view) {
                if(typeof root._basewin._view !== "undefined" || root._basewin._view === null){
                    root._basewin._view.destroy();
                }
                root._basewin.add(view, {left: 0, top: 50, right: 0, height:"92%"});
                root._basewin._view = view;
            },
            getMenuBar: function () {
                var frame = new qx.ui.container.Composite(new qx.ui.layout.Grow());

                var menubar = new qx.ui.menubar.MenuBar();
                //menubar.setWidth(600);
                frame.add(menubar);

                var homeMenu = new qx.ui.menubar.Button(this.tr("Home"), null, this.getHomeMenu());
                var adminhMenu = new qx.ui.menubar.Button("Administration", null, this.getAdminMenu());
                let salesMenu = new qx.ui.menubar.Button("Sales", null, this.getSalesMenu());
                let stockMenu = new qx.ui.menubar.Button("Stock", null, this.getStockMenu());

                /* var viewMenu = new qx.ui.menubar.Button("View", null, this.getViewMenu());
                 var formatMenu = new qx.ui.menubar.Button("Format", null, this.getFormatMenu());
                 var helpMenu = new qx.ui.menubar.Button("Help", null, this.getHelpMenu());*/

                menubar.add(homeMenu);
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
            getAdminMenu: function () {
                let that = this;
                let menu = new qx.ui.menu.Menu();

                let usersButton = new qx.ui.menu.Button("Users");
                let stockitemButton = new qx.ui.menu.Button("Stockitems");
                let pricelistButton = new qx.ui.menu.Button("Pricelists");
                let customerButton = new qx.ui.menu.Button("Customers");
                let settingsButton = new qx.ui.menu.Button("Settings");
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
                settingsButton.addListener("execute", this.settingsButton);

                menu.add(usersButton);
                menu.add(stockitemButton);
                menu.add(pricelistButton);
                menu.add(customerButton);

                menu.addSeparator();
                menu.add(settingsButton);

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
            settingsButton:function() {
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

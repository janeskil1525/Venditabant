qx.Class.define ( "venditabant.application.ApplicationWindow",
    {
        extend : qx.ui.window.Window,

        construct : function (  ) {
            this.base ( arguments );
            this.createCommands();
            this.setLayout ( new qx.ui.layout.Canvas ( ) );
            this.setWidth  ( 800 );
            this.setHeight ( 550 );

            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot ( );
            root.add ( this, { top: 10, left: 10 } );

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
                container.setAllowStretchX(false);
                scroller.add(container);
                this.add(scroller, {edge: 0});

                var bar = this.getMenuBar();
                container.add(bar, {left: 52, top: 0});
                this._menubar = bar;
                var lbl = new qx.ui.basic.Label(this.tr("Hello World"));
                lbl.setFont(font);
                this.add(lbl, {top: "50%", left: "40%"});

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
            },
            getMenuBar: function () {
                var frame = new qx.ui.container.Composite(new qx.ui.layout.Grow());

                var menubar = new qx.ui.menubar.MenuBar();
                menubar.setWidth(600);
                frame.add(menubar);

                var fileMenu = new qx.ui.menubar.Button("File", null, this.getFileMenu());
                var editMenu = new qx.ui.menubar.Button("Edit", null, this.getEditMenu());
                var adminhMenu = new qx.ui.menubar.Button("Administration", null, this.getAdminMenu());
                /* var viewMenu = new qx.ui.menubar.Button("View", null, this.getViewMenu());
                 var formatMenu = new qx.ui.menubar.Button("Format", null, this.getFormatMenu());
                 var helpMenu = new qx.ui.menubar.Button("Help", null, this.getHelpMenu());*/

                menubar.add(fileMenu);
                menubar.add(editMenu);
                menubar.add(adminhMenu);

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
            createCommands: function () {
                this._newCommand = new qx.ui.command.Command("Ctrl+N");
                this._newCommand.addListener("execute", this.debugCommand);

                this._openCommand = new qx.ui.command.Command("Ctrl+O");
                this._openCommand.addListener("execute", this.debugCommand);

                this._saveCommand = new qx.ui.command.Command("Ctrl+S");
                this._saveCommand.addListener("execute", this.debugCommand);

                this._undoCommand = new qx.ui.command.Command("Ctrl+Z");
                this._undoCommand.addListener("execute", this.debugCommand);

                this._redoCommand = new qx.ui.command.Command("Ctrl+R");
                this._redoCommand.addListener("execute", this.debugCommand);

                this._cutCommand = new qx.ui.command.Command("Ctrl+X");
                this._cutCommand.addListener("execute", this.debugCommand);

                this._copyCommand = new qx.ui.command.Command("Ctrl+C");
                this._copyCommand.addListener("execute", this.debugCommand);

                this._pasteCommand = new qx.ui.command.Command("Ctrl+P");
                this._pasteCommand.addListener("execute", this.debugCommand);

                this._pasteCommand.setEnabled(false);
            },
            getFileMenu: function () {
                var menu = new qx.ui.menu.Menu();

                var newButton = new qx.ui.menu.Button("New", "icon/16/actions/document-new.png", this._newCommand);
                var openButton = new qx.ui.menu.Button("Open", "icon/16/actions/document-open.png", this._openCommand);
                var closeButton = new qx.ui.menu.Button("Close");
                var saveButton = new qx.ui.menu.Button("Save", "icon/16/actions/document-save.png", this._saveCommand);
                var saveAsButton = new qx.ui.menu.Button("Save as...", "icon/16/actions/document-save-as.png");
                var printButton = new qx.ui.menu.Button("Print", "icon/16/actions/document-print.png");
                var exitButton = new qx.ui.menu.Button("Exit", "icon/16/actions/application-exit.png");

                newButton.addListener("execute", this.debugButton);
                openButton.addListener("execute", this.debugButton);
                closeButton.addListener("execute", this.debugButton);
                saveButton.addListener("execute", this.debugButton);
                saveAsButton.addListener("execute", this.debugButton);
                printButton.addListener("execute", this.debugButton);
                exitButton.addListener("execute", this.debugButton);

                menu.add(newButton);
                menu.add(openButton);
                menu.add(closeButton);
                menu.add(saveButton);
                menu.add(saveAsButton);
                menu.add(printButton);
                menu.add(exitButton);

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

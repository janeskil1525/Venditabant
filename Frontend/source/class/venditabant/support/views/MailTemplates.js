

qx.Class.define ( "venditabant.support.views.MailTemplates",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"}
        },
        members: {
            // Public functions ...
            __table : null,
            _default_mailer_mails_pkey: 0,
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "63%"});
                let page1 = this.getDefinition();
                tabView.add(page1);

                this._createTable();
                view.add(this._table,{top:"65%", left:5, right:5,height:"35%"});
                this.loadTemplates();

                return view;
            },
            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Definition"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Header" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let header = this._createTextArea(this.tr("Header"), 500, 80);
                page1.add ( header, { top: 10, left: 90 } );
                this._header = header;

                lbl = this._createLbl(this.tr( "Body" ), 70);
                page1.add ( lbl, { top: 95, left: 10 } );

                let body = this._createTextArea(this.tr("Body"), 500, 80);
                page1.add ( body, { top: 95, left: 90 } );
                this._body = body

                lbl = this._createLbl(this.tr( "Footer" ), 70);
                page1.add ( lbl, { top: 180, left: 10 } );

                let footer =  this._createTextArea(this.tr("Footer"), 500, 80);
                page1.add ( footer, { top: 180, left: 90 } );
                this._footer = footer;

                lbl = this._createLbl(this.tr( "Sub 1" ), 70);
                page1.add ( lbl, { top: 10, left: 600 } );

                let sub1 = this._createTextArea(this.tr("Sub 1"), 270, 80);
                page1.add ( sub1, { top: 10, left: 670 } );
                this._sub1 = sub1;

                lbl = this._createLbl(this.tr( "Sub 2" ), 70);
                page1.add ( lbl, { top: 95, left: 600 } );

                let sub2 = this._createTextArea(this.tr("Sub 2"), 270, 80);
                page1.add ( sub2, { top: 95, left: 670 } );
                this._sub2 = sub2;

                lbl = this._createLbl(this.tr( "Sub 3" ), 70);
                page1.add ( lbl, { top: 180, left: 600 } );

                let sub3 = this._createTextArea(this.tr("Sub 3"), 270, 80);
                page1.add ( sub3, { top: 180, left: 670 } );
                this._sub3 = sub3;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveTemplate( );
                }, this );
                page1.add ( btnSignup, { bottom: 5, left: 10 } );



                let template = new venditabant.support.views.MailTemplatesSelectBox().set({
                    width:250,
                    emptyrow:true,
                    callback:this,
                });
                let templateview = template.getView();
                this._template = template;
                page1.add ( templateview, { bottom: 5, left: 150 } );

                let companies = new venditabant.company.views.CompaniesSelectBox().set({
                    width:180,
                    emptyrow:true,
                });
                let companiessview = companies.getView()
                this._companies = companies;
                page1.add ( companiessview, { bottom: 5, right: 350 } );

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:180,
                    emptyrow:false,
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { bottom: 5, right: 150 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page1.add ( btnCancel, { bottom: 5, right: 10 } );

                return page1;
            },
            saveTemplate:function() {
                let that = this;

                let header  = this._header.getValue();
                let body = this._body.getValue();
                let footer = this._footer.getValue();
                let languages_fkey = this._languages.getKey();
                let companies_fkey = this._companies.getKey();
                let mailer_fkey = this._template.getKey();
                let sub1 = this._sub1.getValue();
                let sub2 = this._sub2.getValue();
                let sub3 = this._sub3.getValue();
                let data = {
                    header_value: header,
                    body_value: body,
                    footer_value: footer,
                    languages_fkey: languages_fkey,
                    companies_fkey: companies_fkey,
                    mailer_fkey: mailer_fkey,
                    default_mailer_mails_pkey: that._default_mailer_mails_pkey,
                    sub1:sub1,
                    sub2:sub2,
                    sub3:sub3,
                }
                let model = new venditabant.support.models.MailTemplates();
                model.saveTemplate(data,function ( success ) {
                    if (success === 'success') {
                        that.loadTemplates(this._template.getKey());
                        that.clearScreen();
                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);

            },
            clearScreen:function() {
                this._header.setValue('');
                this._body.setValue('');
                this._footer.setValue('');
                this._sub1.setValue('');
                this._sub2.setValue('');
                this._sub3.setValue('');
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Header", "Body", "Footer", "Language", 'languages_fkey', 'sub1', 'sub2', 'sub3' ]);
                tableModel.setData(rowData);

                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 800,
                    height: 200
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                    var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });
                    that._default_mailer_mails_pkey = selectedRows[0][0];
                    that._header.setValue(selectedRows[0][1]);
                    that._body.setValue(selectedRows[0][2]);
                    that._footer.setValue(selectedRows[0][3]);
                    that._languages.setKey(selectedRows[0][5])
                    that._sub1.setValue(selectedRows[0][6]);
                    that._sub2.setValue(selectedRows[0][7]);
                    that._sub3.setValue(selectedRows[0][8]);
                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(5,false);
                tcm.setColumnWidth(1,200)
                tcm.setColumnWidth(2,500)
                tcm.setColumnWidth(2,200)
                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(4, new qx.ui.table.cellrenderer.Boolean());
                //tcm.setDataCellRenderer(5, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer

                this._table = table;
            },
            loadTemplates:function (mailer_fkey) {
                let mailtemplates = new venditabant.support.models.MailTemplates();
                mailtemplates.loadList(function(response) {
                    let tableData = [];
                    if(response.data !== null) {
                        for(let i = 0; i < response.data.length; i++) {
                            tableData.push([
                                response.data[i].default_mailer_mails_pkey,
                                response.data[i].header_value,
                                response.data[i].body_value,
                                response.data[i].footer_value,
                                response.data[i].lan,
                                response.data[i].languages_fkey,
                                response.data[i].sub1,
                                response.data[i].sub2,
                                response.data[i].sub3,
                            ]);
                        }
                    }

                    this._table.getTableModel().setData(tableData);
                    //alert("Set table data here");
                }, this, mailer_fkey);
                //return ;//list;
            }
        }
    });

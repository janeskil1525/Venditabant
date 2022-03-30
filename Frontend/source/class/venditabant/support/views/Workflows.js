/*function onStartedDownload(id) {
    console.log(`Started downloading: ${id}`);
}

function onFailed(error) {
    console.log(`Download failed: ${error}`);
}*/

var downloadUrl = new venditabant.application.Const().venditabant_endpoint() + '/api/v1/workflows/export/';

/*var downloading = browser.downloads.download({
    url : downloadUrl,
    filename : 'workflows.sql',
    conflictAction : 'uniquify'
});*/

function request() {
    window.location = downloadUrl;
}

qx.Class.define ( "venditabant.support.views.Workflows",
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
                view.add(tabView, {top: 0, left: 5, right: 5, height: "97%"});
                let page1 = this.getDefinition();
                tabView.add(page1);

                //this._createTable();
                //view.add(this._table,{top:"65%", left:5, right:5,height:"35%"});
                //this.loadTemplates();

                return view;
            },
            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Workflows"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let workflow_xml = this._createTextArea(this.tr("Workflow"), 925, 430);
                page1.add ( workflow_xml, { top: 50, left: 10 } );
                this._workflow_xml = workflow_xml;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveWorkflow( );
                }, this );
                page1.add ( btnSignup, { bottom: 5, left: 10 } );

                let workflow = new venditabant.support.views.WorkflowSelectBox().set({
                    width:250,
                    emptyrow:false,
                    callback:this,
                });
                let workflowview = workflow.getView();
                this._workflow = workflow;
                page1.add ( workflowview, { top: 10, left: 10 } );

                let part = new venditabant.support.views.PartSelectBox().set({
                    width:180,
                    callback:this,
                    emptyrow:false,
                });
                let partview = part.getView()
                this._part = part;
                page1.add ( partview, { top: 10, left: 270 } );

                let btnExport = this._createBtn ( this.tr ( "Export" ), "#FFAAAA70", 135, function ( ) {
                    this.exportWorkflows ( );
                }, this );
                page1.add ( btnExport, { bottom: 5, right: 200 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page1.add ( btnCancel, { bottom: 5, right: 10 } );

                return page1;
            },
            exportWorkflows:function() {
                let workflow = new venditabant.support.models.Workflows();
                workflow.export(function(response) {
                    let tableData = [];
                    if(response.data !== null) {
                       this._workflow_xml.setValue(response.data);
                    }
                    //alert("Set table data here");
                }, this);
            },
            saveWorkflow:function() {
                let that = this;

                let workflow  = this._workflow_xml.getValue();
                let workflows_fkey = this._workflow.getModel().workflows_pkey;
                let workflow_type = this._part.getModel();
                let data = {
                    workflow: workflow,
                    workflows_fkey: workflows_fkey,
                    workflow_type: workflow_type,
                }
                let model = new venditabant.support.models.Workflows();
                model.save(data,function ( success ) {
                    if (success === 'success') {

                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);

            },
            clearScreen:function() {
                this._workflow_xml.setValue('');
            },
            loadWorkflow:function (workflows_pkey, workflow_type) {

                if (typeof workflows_pkey === 'undefined') {
                    if(typeof this._workflow !== 'undefined') {
                        if(typeof this._workflow.getModel() !== 'undefined') {
                            workflows_pkey = this._workflow.getModel().workflows_pkey;
                        }
                    }
                }

                if (typeof workflow_type === 'undefined') {
                    if(typeof this._part !== 'undefined') {
                        if(typeof this._part.getModel() !== 'undefined') {
                            workflow_type = this._part.getModel();
                        }
                    }
                }

                if(typeof workflow_type !== 'undefined' && typeof workflows_pkey !== 'undefined') {
                    let workflow = new venditabant.support.models.Workflows();
                    workflow.load(function(response) {
                        let tableData = [];
                        if(response.data !== null) {
                            this._workflow_xml.setValue(response.data.workflow);
                        }
                        //alert("Set table data here");
                    }, this, workflows_pkey, workflow_type);
                    //return ;//list;
                }
            }
        }
    });

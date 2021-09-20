/* ************************************************************************

   Copyright:

   License:

   Authors:

************************************************************************ */

/**
 * TODO: needs documentation
 */
qx.Class.define("delivery.page.Overview",
{
  extend : qx.ui.mobile.page.NavigationPage,

  construct : function()
  {
    this.base(arguments);
    this.setTitle("Delivery");
    this.setShowBackButton(true);
    this.setBackButtonText("Back");
  },


  members :
  {
    // overridden
    _selectedCustomer : null,
    _selectedStockitem:null,
    _initialize : function()
    {
      this.base(arguments);

      let layout = new qx.ui.mobile.layout.HBox();

      let lbl = new qx.ui.mobile.basic.Label(this.tr("Select customer : "));
      let cust = this.setupCustomerList();
      let container = new qx.ui.mobile.container.Composite(layout);
      container.add(lbl,{flex:1});
      container.add(cust);

      this.getContent().add(container);

      this._selectedStockitem = new qx.ui.mobile.basic.Label("No stockitem selected");
      this.getContent().add(this._selectedStockitem);

      let layout1 = new qx.ui.mobile.layout.HBox();
      this._quantity = new qx.ui.mobile.form.NumberField(0);
      let container1 = new qx.ui.mobile.container.Composite(layout1);
      container1.add(this._quantity);
      this._quantity.setPlaceholder(this.tr("Quantity"));

      let but = new qx.ui.mobile.form.Button(this.tr("Add"));
      but.addListener("tap", function() {
        if(this._quantity.getValue() > 0) {
          let data = {
            customer:this._selectedCustomer.item,
            quantity:this._quantity.getValue(),
            stockitem:this._selectedStockitem.getValue(),
            price:10
          };

          let sales = new delivery.models.Salesorders();
          sales.add(function(success) {
            if (success) {
              this._quantity.setValue(0);
              this._selectedStockitem.setValue('No stockitem selected');
            } else {
              alert(this.tr("Could not save item, please try again"));
            }
          }, this, data);
        }
      }, this);
      container1.add(but)
      this.getContent().add(container1);

      this.getContent().add(but);
      this.loadStockitemList();



      //var title = new qx.ui.mobile.form.Title("item2");
      // title.bind("value",sel,"value");
      // this._customers.bind("value",title,"value");
      //this.getContent().add(title);
    },
    addSaveButton:function() {
      let but = new qx.ui.mobile.form.Button(this.tr("Save"));
      this.getContent().add(but);
      but.addListener("tap", function(){
        // sel.setSelection("item3");
      }, this);
    },
    setupCustomerList:function() {

      let customers = new qx.ui.mobile.form.SelectBox();
      customers.addListener("changeSelection", function(evt) {
        this._selectedCustomer = evt.getData();
      }, this);
      let cust = new delivery.models.Customers();
      cust.loadList(function(response) {
        let tableData = new qx.data.Array();;
        for(let i = 0; i < response.data.length; i++) {
          tableData.append(response.data[i].customer);
        }
        customers.setModel(tableData);
      }, this);
      return customers;
      //this.getContent().add(customers);
      // this._customers = customers;
      // this._loadCustomers();
    },
    _loadCustomers: function () {
      let cust = new delivery.models.Customers();
      cust.loadList(function(response) {
          let tableData = [];
          for(let i = 0; i < response.data.length; i++) {
            let tempItem = new qx.ui.form.ListItem(response.data[i].customer);
            cust.add(tempItem);
          }
        }, this);
      },
    loadStockitemList:function() {
      let that = this;
      let stock = new delivery.models.Stockitems();
      let data = [];

      stock.loadList(function(response) {
          for(let i = 0; i < response.data.length; i++) {
            data.push({
              title:response.data[i].stockitem,
              subtitle:response.data[i].description
            })
          }
        that.createUiList(data);
        that.addSaveButton();
      });
    },
    createUiList:function(data) {
      let list = new qx.ui.mobile.list.List({
        configureItem: function(item, data, row)
        {
          item.setImage("path/to/image.png");
          item.setTitle(data.title);
          item.setSubtitle(data.subtitle);
        },
        configureGroupItem: function(item, data) {
          item.setTitle(data.title);
        },
        group: function(data, row) {
          return {
            title: row < 2 ? "Selectable" : "Unselectable"
          };
        }
      });

      list.setModel(new qx.data.Array(data));
      list.addListener("changeSelection", function(evt) {

        let data = this._list.getModel().toArray()[evt.getData()];

        this._selectedStockitem.setValue(data.title);
        this._quantity.setVisibility('visible');


      }, this);

      this.getContent().add(list);
      this._list = list;
    },
    // overridden
    _back : function(triggeredByKeyEvent)
    {
      qx.core.Init.getApplication().getRouting().back();
    }
  }
});

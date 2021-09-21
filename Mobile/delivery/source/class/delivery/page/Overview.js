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
      let row = new qx.ui.mobile.form.Row();
      this.getContent().add(row);

      let layout1 = new qx.ui.mobile.layout.HBox();
      this._quantity = new qx.ui.mobile.form.NumberField(0);
      let container1 = new qx.ui.mobile.container.Composite(layout1);
      container1.add(this._quantity);
      this._quantity.setPlaceholder(this.tr("Quantity"));
      row = new qx.ui.mobile.form.Row();
      this.getContent().add(row);

      let but = new qx.ui.mobile.form.Button(this.tr("Add"));
      but.addListener("tap", function() {
        if(this._quantity.getValue() > 0) {
          let stock = this._selectedStockitem.getValue();
          let stockitem = stock.substring(0,stock.indexOf(' - '));

          let data = {
            customer:this._selectedCustomer.item,
            quantity:this._quantity.getValue(),
            stockitem:stockitem,
            price:10
          };

          let sales = new delivery.models.Salesorders();
          sales.add(function(success) {
            if (success) {
              this._quantity.setValue(0);
              this._selectedStockitem.setValue('No stockitem selected');
              this.loadStockitemList(this._selectedCustomer.item, true);
            } else {
              alert(this.tr("Could not save item, please try again"));
            }
          }, this, data);
        }
      }, this);
      container1.add(but)
      this.getContent().add(container1);
      this.getContent().add(but);
      row = new qx.ui.mobile.form.Row();
      this.getContent().add(row);
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
      let recreate = true;
      customers.addListener("changeSelection", function(evt) {
        this._selectedCustomer = evt.getData();
        if(this._list === null || typeof this._list === 'undefined') {
          recreate = false;
        } else {
          recreate = true;
        }
        this.loadStockitemList(this._selectedCustomer.item, recreate);
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
    loadStockitemList:function(customer, recreate) {
      let that = this;
      let stock = new delivery.models.Stockitems();
      let data = [];

      stock.loadListSales(function(response) {
          let groupCount = response.data.salesorders.length;
          for(let i = 0; i < response.data.salesorders.length; i++) {
            data.push({
              title:response.data.salesorders[i].stockitem + " - " + response.data.salesorders[i].description,
              subtitle: this.tr("Price :") + response.data.salesorders[i].price + this.tr(" Quantity : ") + response.data.salesorders[i].quantity,
              groupType:'salesorders',
              groupCount:groupCount,
            })
          }
        groupCount += response.data.history.length;
        for(let i = 0; i < response.data.history.length; i++) {
          data.push({
            title:response.data.history[i].stockitem + " - " + response.data.history[i].description,
            subtitle: this.tr("Price :") + response.data.history[i].price + this.tr(" Quantity : ") + response.data.history[i].quantity,
            groupType:'history',
            groupCount:groupCount,
          })
        }
        groupCount += response.data.stockitems.length;
          for(let i = 0; i < response.data.stockitems.length; i++) {
            data.push({
              title:response.data.stockitems[i].stockitem + " - " + response.data.stockitems[i].description,
              subtitle: this.tr("Price :") + response.data.stockitems[i].price + this.tr(" Quantity : ") + response.data.stockitems[i].quantity,
              groupType:'stockitems',
              groupCount:groupCount,
            })
          }
          if(recreate === true) {
            that.recreateUIList(data);
          } else {
            that.createUiList(data);
            that.addSaveButton();
          }
      }, this, customer);
    },
    recreateUIList(data) {
      this._list.resetModel();
      this._list.setModel(new qx.data.Array(data));
    },
    createUiList:function(data) {
      let that = this;
      let list = new qx.ui.mobile.list.List({
        configureItem: function(item, data, row)
        {
          // item.setImage("path/to/image.png");
          item.setTitle(data.title);
          item.setSubtitle(data.subtitle);
        },
        configureGroupItem: function(item, data) {
          item.setTitle(data.title);
        },
        group: function(data, row) {
          if(data.groupType === 'salesorders') {
            return {
              title: that.tr("Salesorder")
            }
          }
          if(data.groupType === 'history') {
            return {
              title: that.tr("History")
            }
          }
          if(data.groupType === 'stockitems') {
            return {
              title: that.tr("Stockitems")
            }
          }
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

qx.Class.define ( "venditabant.cockpit.views.Cockpit",
    {
        extend: venditabant.application.base.views.Base,
        construct: function () {

        },
        destruct: function () {
        },
        members: {
            getView: function () {
                var view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());

                var tabView = new qx.ui.tabview.TabView();
                tabView.setWidth(800);
                tabView.setHeight(300);
                view.add(tabView, {top: 0, left: 5, right: 5, height: "100%"});

                var page1 = new qx.ui.tabview.Page("Todo");

                page1.setLayout(new qx.ui.layout.Canvas());

                var page2 = new qx.ui.tabview.Page("Status");
                page2.setLayout(new qx.ui.layout.Canvas());
                tabView.add(page1);
                tabView.add(page2);

                return view
            }
        }
    });
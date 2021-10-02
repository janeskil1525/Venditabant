qx.Class.define ( "venditabant.cockpit.views.Cockpit",
    {
        extend: qx.core.Object,
        construct: function () {

        },
        destruct: function () {
        },
        members: {
            getView:function() {
                var stack = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                //this.add(stack, {left: 5, top: 50, right: 5, height:"86%"});
                stack.setBackgroundColor("green");
                //this._stack = stack;

                return stack;

            }
        }
    });
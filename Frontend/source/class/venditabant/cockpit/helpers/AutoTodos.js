qx.Class.define("venditabant.cockpit.helpers.AutoTodos",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {

        },
        members: {
            runCheckPoints:function() {
                let checkpoint = new venditabant.cockpit.models.AutoTodos();
                checkpoint.run_checkpoints(function(){
                    let root  = qx.core.Init.getApplication ( ).getRoot();
                    let view = new venditabant.cockpit.views.AutoTodo();
                    root._basewin.addView(root, view);
                }, this);
            }
        }
    });
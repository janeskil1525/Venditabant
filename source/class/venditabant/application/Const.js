qx.Class.define("venditabant.application.Const",
    {
        type: "singleton",
        construct : function() {

        },
        destruct : function() {

        },
            members: {
                venditabant_endpoint: function(mode) {
                        if (mode === 'test') {
                                return 'http://192.168.1.134';
                        } else {
                                return 'live address';
                        }
                }
            }

    });
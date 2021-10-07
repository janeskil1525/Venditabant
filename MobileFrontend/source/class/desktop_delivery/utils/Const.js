qx.Class.define("desktop_delivery.utils.Const",
    {
        extend: qx.core.Object,
        // type: "singleton",
        construct : function() {

        },
        destruct : function() {

        },
            members: {
                _mode : 'live',
                venditabant_endpoint: function() {
                        if (this._mode === 'test') {
                                return 'http://192.168.1.134';
                        } else {
                                return 'https://www.venditabant.net';
                        }
                }
            }

    });
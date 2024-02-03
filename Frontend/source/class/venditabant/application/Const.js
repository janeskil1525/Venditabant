qx.Class.define("venditabant.application.Const",
    {
        extend: qx.core.Object,
        // type: "singleton",
        construct : function() {

        },
        destruct : function() {

        },
        members: {
            _mode : 'test',
            venditabant_endpoint: function() {
                if (this._mode === 'test') {
                    return 'http://192.168.1.134';
                } else {
                    return 'https://www.venditabant.net';
                }
            },
            getVersion:function() {
                return "0.1.3"
            },
            venditabant_port:function() {
                if (this._mode === 'test') {
                    return '30001';
                } else {
                    return '3000';
                }
            }
        }

    });
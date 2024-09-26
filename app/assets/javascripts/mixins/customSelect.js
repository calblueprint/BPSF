var customSelect = {
    convertSelects: function(){
            if(document.width < 1040){
                return;
            }

            var me = this,
                selects = me.documentObject.querySelectorAll('select');

            for (var i = selects.length - 1; i >= 0; i--) {
                (function(){
                    var oldSelect = selects[i],
                        scope = oldSelect.parentNode,
                        newSelect = me.createSelect(oldSelect);

                    oldSelect.className = 'hide';
                    scope.insertBefore(newSelect, oldSelect);
                    me.manageSelect(newSelect, oldSelect);

                })();
            };
        },

    createSelect: function(oldSelect){
            var newSelectHTML = '<div class="select-wrapper"><span>';
            if (oldSelect.value) {
                for (var i = 0; i < oldSelect.options.length; i++) {
                    if (oldSelect.options[i].value == oldSelect.value) {
                        newSelectHTML += $(oldSelect.options[i]).text();
                    }
                }
            } else {
                newSelectHTML += $(oldSelect.options[0]).text();
            }
            newSelectHTML += '</span><ul class="select">';

            for (var i = 0; i < oldSelect.options.length; i++) {
                if(oldSelect.options[i].value){
                    newSelectHTML += '<li data-bp-value="'
                    + oldSelect.options[i].value + '"><a>'
                    + $(oldSelect.options[i]).text()
                    + '</a></li>';
                }
            };

            newSelectHTML += '</ul></div>';

            var tempDiv = document.createElement('div');
                tempDiv.innerHTML = newSelectHTML;

            return tempDiv.firstChild
        },

    manageSelect: function(newSelect, oldSelect){
            var me = this;

            $(newSelect).on('click', function(e){
                me.flipElementStates(newSelect);
                e.preventDefault();
                return false;
            })

            var options = newSelect.querySelectorAll('li');

            for (var i = options.length - 1; i >= 0; i--) {
                (function(){
                    var thisOption = options[i];
                    $(thisOption).on('click', function(e){
                        oldSelect.value = thisOption.getAttribute('data-bp-value');
                        $(newSelect).children('span').first().text($(thisOption).text());

                        me.deactivateElements.apply(me, options);
                        me.activateElements(false, thisOption);
                        me.deactivateElements(newSelect);

                        $(oldSelect).trigger('change');

                        e.preventDefault();
                        return false;
                    });
                })();
            };
        }
}

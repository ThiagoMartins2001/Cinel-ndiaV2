$(document).ready(function(){
    function initldBar(barElement) {
        var bar = new ldBar(barElement, {
            "value": 0,
            "fill-background-extrude": 0,
            "type": 'fill',
            "label": false,
            "min": 1,
            "max": 100,
        });
        return bar;
    }
    
    function initldBar2(bar, timer, id) {
        var interval = timer / 100; 
        
        var progress = 0;
        var progressInterval = setInterval(function() {
            progress++;
            bar.set(progress);
            if (progress >= 100) {
                clearInterval(progressInterval);
                $('#' + id).fadeOut(500, function() {
                    $(this).remove(); 
                });
            }
        }, interval);
    }
    
    window.addEventListener("message", function(event) {
        if (event.data.notify !== undefined) {

            var html = `
            <div id='${event.data.css}'>
                <div class="box-fora">
                    <div class="loadbar" data-img="assets/${event.data.box}.svg" data-label="false"></div>
                    <div class="icon">
                        <img src="assets/${event.data.css}.svg" onerror="if (this.src != 'assets/notifyindisponivel.svg') this.src = 'assets/notifyindisponivel.svg';">
                    </div>
                </div>
                <div class="content">
                    <div class="textn">${event.data.textn}</div>
                    <div class="textn2">${event.data.mensagem}</div>
                </div>
            </div>
            `;
            
            var notification = $(html).hide().appendTo("#notifications").fadeIn(500).delay(event["data"]["timer"]).fadeOut(500);
            var barElement = notification.find('.loadbar')[0];
            var bar = initldBar(barElement);
            
            setTimeout(function() {
                initldBar2(bar, event.data.timer, event.data.css);
            }, 100);
        }
    });
});

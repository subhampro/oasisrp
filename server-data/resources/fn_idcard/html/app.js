$(function(){
    function display(bool){
        if (bool){
            $(".container").fadeIn();
        } else {
            $(".container").fadeOut();
        }
     }

     display(false);

     function SendStatus(name, group, job, cash, bank, dirty){
         $(".title").text(name);
         $(".job-title").text(job);
         $("#group_name").text(group);
         $("#cash").text(cash);
         $("#bank").text(bank);
         $("#dirty").text(dirty);
     }

window.addEventListener('message', function(event){
    var item = event.data;
    if (item.status == true){
        SendStatus(item.name, item.group, item.job, item.cash, item.bank, item.dirty);
        display(true);
    } else {
        display(false);
    }
})

document.onkeyup = function(data){
    if (data.which == 27){
        $.post('http://fn_idcard/close', JSON.stringify({}));
        return
    }
};

$("#close").click(function(){
    $.post('http://fn_idcard/close', JSON.stringify({}));
    return
})

});
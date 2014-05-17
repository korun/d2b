(function($){
    $.fn.set_back = function( back_str ) {
        var str = back_str == "none" ? back_str : 'url(/assets/' + back_str + ')';
        return this.css('background-image', str);
    };
})(jQuery);
var Units;
var GAME_ID,
    Step,
    Listen,
    LEFTSIDE  = 0,
    RIGHTSIDE = 1;

function initialize_game(g_id, face_0, face_1) {
    GAME_ID = g_id;
    $('#player0_face').set_back('lord_face/' + face_0 + '.gif');
    $('#player1_face').set_back('lord_face/' + face_1 + '.gif');
    $('#defend').hide().click(function(){unit_defend();});
    Step = -2;
    Listen = true;
    listen();
//    initialize_units();
    $('.lessh').click(function(){if($(this).is(".atrgt,.htrgt,.strgt")) unit_do($(this).attr('id').substr(3));});
}
function initialize_units(data) {
    Units = data;
    for (var i = 0; i < Units.length; i++) {
        render_unit(Units[i]);
    }
}
//function initialize_units() {
//      $.get("/games/" + GAME_ID + "/units.json",
//          function (data) {
//              Units = data;
//              for (var i = 0; i < Units.length; i++) {
//                  render_unit(Units[i]);
//              }
//              getActiveU();
//          }, "json");
//}
function render_unit(obj) {
    var image_url = '' + obj.prototype.race + '/' + obj.prototype.id;
    showhlth(obj, obj.cell_num);
    $('#pU' + obj.cell_num).set_back(image_url + '/face.gif');
    $('#lhU' + obj.cell_num).attr('title', obj.prototype.name);
    if(obj.defend) $('#defU' + obj.cell_num).show();
    if(obj.health <= 0) kill(obj.cell_num,(obj.prototype.big ? 1 : 0));
    else $('#U' + obj.cell_num).set_back(image_url + '/stand' + (obj.cell_num < 7 ? LEFTSIDE : RIGHTSIDE) + '.png');
//    если толстый...
    if(obj.prototype.big){
        var j;
        if(obj.cell_num < 7) j = obj.cell_num - 1;
        else j = obj.cell_num + 1;
        $('#pU' + j + ',#hU' + j).hide();
        $('#pU' + obj.cell_num + ',#hU' + obj.cell_num).css('width','150px').not('#pU' + obj.cell_num).css('background','url(/assets/i/hlbar.gif) repeat-x 50% 50%');
        $('#dnU' + obj.cell_num).css('left','60px');
    }

}
function showhlth(tu, n) {
    $('#hU' + n).html(tu.health + '/' + tu.health_max);
    $('#lhU' + n).css('background-position', '50% ' + Math.floor(85 * tu.health / tu.health_max) + 'px').set_back('i/dmg.png');
    $('#dnU' + n).html('');
}
function getActiveU(){
    sendGet({ act: "getActive" });
}
function sendGet(params, func){
    params = params || {};
    func = func || function(){};
    return $.post("/games/" + GAME_ID + "/make_action.js", params, func);
}
function set_border(a){
    for(var i = 0; i < a.length; i++){
        $('#cU' + a[i][0]).set_back('i/_' + a[i][1] + a[i][2] + 'trgt.png');
        $('#lhU' + a[i][0]).addClass(a[i][2] + 'trgt');
    }
}
function find_unit(cell_num){
    for (var i = 0; i < Units.length; i++)
        if(Units[i].cell_num == ~~cell_num) return i;
    return null;
}
function unit_do(cell_num){
    cleartrgt();
    var unit_i = find_unit(cell_num);
    sendGet({ act: "do", target_id: Units[unit_i].id, target_i: unit_i });
    Step++;
}
function unit_defend(){
    var unit_i = find_unit($('#content .active').attr('id').substr(3));
    cleartrgt();
    sendGet({ act: "defend", target_i: unit_i });
    Step++;
}
function cleartrgt(){
    $('#defend').hide();
    $('.lessh').removeClass('atrgt strgt htrgt active');
    $('.circle0,.circle1').css("background-image","none");
}
function kill(cnkill, big){ //~ delete unit
    var unit_i = find_unit(cnkill);
    $('#U'+cnkill).set_back('i/bones'+Math.round(Math.random())+'.png');
    $('#lhU'+cnkill).set_back('i/MASKDEAD'+big+'.png');
    Units[unit_i].dead = true;
}
function attack_animation(cell_num, side, path, act_delay){
    $('#U' + cell_num).set_back('' + path + '/attack' + side + '.png');
    setTimeout(function(){
        $('#U' + cell_num).set_back('' + path + '/stand' + side + '.png');
    }, act_delay * 100);
}
function hit_moment(miss, msg, dmg, target_cell_num, act_path, act_side, trgt_side, act_delay){
    setTimeout(function(){
        if(!miss){
            $('#eU' + target_cell_num).set_back('' + act_path + '/effect' + act_side + '.png');
            $('#efU' + target_cell_num).set_back('' + act_path + '/effect' + act_side + '_.png');
        }
        $('#MassEffect' + trgt_side).set_back('' + act_path + '/masseffect' + act_side + '.png');
//        $('#MassEffect' + trgt_side + '_').set_back('' + act_path + '/masseffect' + act_side + '_.png');
        $('#lhU' + target_cell_num).set_back('i/' + msg + '.png').css('background-position','50% 0px');
        $('#dnU' + target_cell_num).html(dmg);
    }, act_delay * 50);
    setTimeout(function(){
        $('#eU' + target_cell_num + ',#efU' + target_cell_num).set_back('none');
    }, act_delay * 100);
}
function mass_hit_moment(trgt_arr, healths, act_path, act_side, trgt_side, act_delay){
    for(var i = 0; i < Units.length; i++){
        if(healths[Units[i].cell_num] !== undefined){
            Units[i].health = healths[Units[i].cell_num];
        }
    }
    setTimeout(function(){
        $('#MassEffect' + trgt_side).set_back('' + act_path + '/masseffect' + act_side + '.png');
//        $('#MassEffect' + trgt_side + '_').set_back('' + act_path + '/masseffect' + act_side + '_.png');
        for(var i = 0; i < trgt_arr.length; i++){
            if(!trgt_arr[i].miss){
                $('#eU'  + trgt_arr[i].cell).set_back('' + act_path + '/effect' + act_side + '.png');
                $('#efU' + trgt_arr[i].cell).set_back('' + act_path + '/effect' + act_side + '_.png');
            }
            $('#lhU' + trgt_arr[i].cell).set_back('i/' + trgt_arr[i].msg + '.png').css('background-position','50% 0px');
            $('#dnU' + trgt_arr[i].cell).html(trgt_arr[i].dmg);
        }
    }, act_delay * 50);
    setTimeout(function(){
        for(var i = 0; i < trgt_arr.length; i++)
            $('#eU' + trgt_arr[i].cell + ',#efU' + trgt_arr[i].cell).set_back('none');
    }, act_delay * 100);
}
function attack_finish(t_index, target_cell_num, dead, trgt_big_num, trgt_side, delay, func){
    func = func || function(){};
    setTimeout(function(){
        $('#MassEffect' + trgt_side).set_back('none');
        showhlth(Units[t_index], target_cell_num);
//        back to stay animation || dead
        setTimeout(function(){
            if(dead)
                kill(target_cell_num, trgt_big_num);
//            else
//                back to stay animation
            func();
        }, 500); //target.delay_h
    }, delay * 50 + 1000);
}
function mass_attack_finish(trgt_side, delay, func){
    func = func || function(){};
    setTimeout(function(){
        $('#MassEffect' + trgt_side).set_back('none');
        for (var i = 0; i < Units.length; i++)
            if(!Units[i].dead) showhlth(Units[i], Units[i].cell_num);
//        back to stay animation || dead
        setTimeout(function(){
            for (var i = 0; i < Units.length; i++){
                if(Units[i].health <= 0 && !Units[i].dead) kill(Units[i].cell_num, (Units[i].prototype.big ? 1 : 0));
//                else back to stay animation
            }
            func();
        }, 500); //target.delay_h
    }, delay * 50 + 1000);
}
function setActiveU(act_cell_num, big_num, border_arr){
    $('#lhU' + act_cell_num).addClass('active');
    $('#cU' + act_cell_num).set_back('i/_' + big_num + 'active.png');
    $('#defU' + act_cell_num).hide();
    if(border_arr != []) set_border(border_arr);
    $('#defend').show();
    $('#infoact' + (act_cell_num < 7 ? LEFTSIDE : RIGHTSIDE)).html("" + Units[find_unit(act_cell_num)].prototype.name + " ходит.");
    $('#infoact' + (act_cell_num < 7 ? RIGHTSIDE : LEFTSIDE)).html("");
}

function set_defend(index, act_cell_num, func){
    func = func || function(){};
    $('#defU' + act_cell_num).show();
    $('#dnU' + act_cell_num).html('defend');
    $('#lhU' + act_cell_num).set_back('i/block.png').css('background-position','50% 0px');
    setTimeout(function(){
        showhlth(Units[index], act_cell_num);
        func();
    }, 1500);
}

function loader(data_array){
    Listen = false;
    var data = eval(data_array);
    if(data != ""){
        var i = 0;
        if(Units === undefined){initialize_units(eval(data[i++]));}

        var int_id = setInterval(function(){
            eval(data[i]);
            i++;
            if(i >= data.length) {
                clearInterval(int_id);
                Listen = true;
            }
        }, 3000);
    }
    else{
        Listen = true;
    }
}

function listen(){
    setInterval(function(){
        if(Listen){
            sendGet({ act: "checkState", step: Step }, function(data){loader(data);});
        }
    }, 3000);
}
function refresh_sum(){
    var gold = 0;
//    var exp = 0;
    $('.unit_select option:selected').each(function(){
        gold += ~~$(this).attr('data-gold');
    });
    $('#gold_count').html(start_gold - gold);
    $('.unit_select option[data-gold]:not(:selected)').each(function(){
        if(~~$(this).attr('data-gold') > start_gold - gold) $(this).attr('disabled', true);
        else $(this).attr('disabled', false);
    });
//    alert(start_gold - gold);
}
function make_unit_select(gold, exp){
    start_gold = gold;
    start_exp = exp;
    $('.unit_select option').each(function(){
        if($(this).attr('data-gold') > 0) $(this).html($(this).html() + " (" + $(this).attr('data-gold') + ")");
        if($(this).attr('data-big')  > 0) $(this).html($(this).html() + " ( ! )");
    });
    var html = $('.unit_select:first').html();
    $('.unit_select:even:gt(0)').each(function(){$(this).html(html);});
    html = $('.unit_select:eq(1)').html();
    $('.unit_select:odd').each(function(){$(this).html(html);});
    $('.unit_select').change(function(){
        var id = parseInt($(this).attr('id').substr(6), 10);
        id = (id < 7 ? id - 1 : id + 1);
        if ($(this).children().filter(":selected").attr('data-big') == 1) $('#units_' + id + '_prototype_id').attr('disabled', true).find('option:first').attr('selected', true);
        else $('#units_' + id + '_prototype_id').attr('disabled', false);
        refresh_sum();
    });
//    $('.portrait').set_back('i/add_unit.png');
    $('#race_id').change(function () {
        var race = ~~$(this).val();
        $(".unit_select").each(function () {
            $(this).attr('disabled', false).find('option:first').attr('selected', true);
        });
        $(".unit_select option[data-race]").each(function () {
            if (race == 0 || race == ~~$(this).attr('data-race')) $(this).show();
            else $(this).hide();
        });
        refresh_sum();
    });
}
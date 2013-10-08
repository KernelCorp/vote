function regCheck() {
  var check = $('#dataUsForm input:checked').length;

  if(check == 1){
    return true;
  } else {
    alert('Вы не согласились с условиями участия.');
    return false;
  }
}


function VoteCell(){
  //console.log($('form[name="voteForm"] .forBtt input').attr('class'));
  if($('form[name="voteForm"] .forBtt input').hasClass('active')){
    $('form[name="voteForm"]').submit();
  }
}

function addPhoneCheck(){
  //console.log($('form[name="voteForm"] .forBtt input').attr('class'));
  if($('form[name="addPhoneForm"] .forBtt .inSbN').hasClass('active')){
    $('form[name="addPhoneForm"]').submit();
  }
}

function prov_adress(obj) {

  if($(".formFB input[name=name]").val() == ''){
       alert('Введите имя');
       return false;
  }

  var adr=$(".formFB input[name=email]").val();
  var adr_pattern=/[0-9a-z_]+@[0-9a-z_]+\.[a-z]{2,5}/i;
  var prov=adr_pattern.test(adr);
  if (prov==true) {
       return true;
  }
  else {
       alert('Email введён не верно');
       return false;
  }
}


$(document).ready(function(){

    $('.delNum').click(function(){
      showpopup("popQtn");
    });

    $('.closeQtn').click(function(){
      $('#popQtn').hide();
      $('#overlay').hide();

    });


  $(".formFB input[name=phone]").keypress (
  function(event)
  {
      var key, keyChar;
    if(!event) var event = window.event;

    if (event.keyCode) key = event.keyCode;
    else if(event.which) key = event.which;

  /*
    если нажата одна из следующих клавиш: enter, tab, backspace, del, стрекла влево, стрелка вправо
    тогда на этом завершаем работу функции, т..к эти клавиши нужны для нормальной работы с полями форм
  */
  if(key==null || key==0 || key==8 || key==13 || key==37 || key==39 || key==46 || key==9) return true;
  keyChar=String.fromCharCode(key);

  /*
    если нажтый символ не является цифрой или "-", или "+", тогда значение поля не меняется
  */
  if(!/[0-9-\+]/.test(keyChar)) return false;

  });






    var widthWrap, totalWrap;

    widthWrap = window.innerWidth;
    totalWrap = 1280;

    if(parseInt(widthWrap) == parseInt(totalWrap)){

      $('body').attr({style:'overflow-x: hidden;'});

    }
    else{
      $('body').removeAttr('style');
    }


  /* Регистрация Начало */
  $('.register_confirm').click(function(){
    $('#register_form_1').hide();
    $('#register_form_2').show();
  });

  $('#profileM1 .arrBL input:first').click(function(){
    $('#register_form_1').show();
    $('#register_form_2').hide();
  });

  $('#profileM1 .arrBL input:last').click(function(){
    if($('.cheG:checked').length == 1){
      $('#register_form_1').show();
      $('#register_form_2').hide();
    }
  });

  $('.sogl .cheG').click(function(){
    $('.arrB .in32').addClass('active');
    $('.usSu').toggleClass('usSu_hover');
  });

  $('.suSuL').click(function(){
    $('.arrB .in32').removeClass('active');
    $('.sogl .cheG').removeAttr('checked');
  });



  /* Регистрация Конец*/

  $('#lCol ul a').eq(3).addClass('nnLiN').text('');

  $('.dataUserNew.numberSize').hover(function(){
    if(!$(this).find('.floatBl').hasClass('active')){
      $(this).find('.floatBl').addClass('active').show();
    }
  },
  function(){
    $(this).find('.floatBl').removeClass('active').hide();
  }
  );


  var hw, ww;
    hw = $('body').height();
    ww = $('body').width();

    $('.blbl').height(hw).width(ww);

      $('.inSbN1').click(function(){
    $('.blbl').show();
    $('#ffrOp2').show();
    });
      $('.cl').click(function(){
    $('.blbl').hide();
    $('#ffrOp2').hide();
  });

  /* $('.polPo').click(function(){
    $('.blbl').show();
    $('#ffrOp1').show();
    }); */
      $('.cl').click(function(){
    $('.blbl').hide();
    $('#ffrOp1').hide();
  });

  $("#dataUsForm").submit(function() {
    var pas1 = $('.inT.godPas').val();
            var pas2 = $('.inT.godPas1').val();
            if(pas1!=pas2){
                $('.inT.godPas').css('border', 'red 1px solid');
                $('.inT.godPas1').css('border', 'red 1px solid');
      return false;
            }
  });

  var widthWindow, heightWindow, scrollWindow;

  heightWindow = $(window).height();
  widthWindow = $(window).width();


  var ht2=0,wid2=0;
  /* $('.forBtt').click(function(){
    scrollWindow = $(window).scrollTop();

    if(!$(this).hasClass('activCb')){
      $(this).addClass('activCb');
      $('.blBg').show().css({'width': widthWindow+ 'px', 'height': heightWindow+ 'px'});
      $('.popBl').show().css({'top': scrollWindow+'px'});
      showpopup('nomon');
      return false;
    }
  }); */
  $('.cl').click(function(){
    $('#overlay').hide();
    $('.popBl').hide();
    $('.forBtt').removeClass('activCb');
    $('.no_money').show();
  });

  $('.cl_m').click(function(){
    $('#overlay').hide();
    $('.popBl').hide();
  });
  $('#overlay').click(function(){
    $('.popup,.popBl').hide();
    $(this).hide();
  });

  var scol=0,it;
  $('.inTx[name*="n_"]').each(function(i){
    $(this).focusin(function(e) {
      $(this).val('');
    })
    $(this).keydown(function(chr){
      it=$(this);
      if((chr.keyCode<48||chr.keyCode>57)&&(chr.keyCode<96||chr.keyCode>105)&&chr.keyCode!=46&&chr.keyCode!=8){
        console.log(chr.keyCode);
        return false;
      } else if((chr.keyCode>=48&&chr.keyCode<=57)||(chr.keyCode>=96&&chr.keyCode<=105)) {
        if(it.val().length==0) {
          setTimeout(function(){
            scol=0;
            $('input[name*="n_"]').each(function(i) {
              if($(this).val() != '') {
                scol+=1;
              }
            });
          },5);
          setTimeout(function(){
            if($('.inTx[name*="n_"]:eq('+(i+1)+')').length>0){
              $('.inTx[name*="n_"]:eq('+(i+1)+')').focus();
            }
            console.log(scol);
            console.log($('.inTx[name*="n_"]').length);
            if(scol>=$('.inTx[name*="n_"]').length){
              $('.inSbN').addClass('active');
            } else {
              $('.inSbN').removeClass('active');
            }
          },10);
        } else {
          if(i<$('.inTx[name*="n_"]').length-1){
            $('.inTx[name*="n_"]:eq('+(i+1)+')').focus();
            it=$('.inTx[name*="n_"]:eq('+(i+1)+')');
            setTimeout(function(){
              //scol+=it.val().length;
            scol=0;
             $('input[name*="n_"]').each(function(i) {
               if($(this).val() != ''){
                 scol+=1;
              }
                         });

                          console.log(scol);
            console.log($('.inTx[name*="n_"]').length);


              if(scol>=$('.inTx[name*="n_"]').length){
                $('.inSbN').addClass('active');
              } else {
                $('.inSbN').removeClass('active');
              }
            },10);
          }
        }
      } else if(chr.keyCode==8){
        if(it.val().length>0){
          setTimeout(function(){
            if(it.val().length==0){
              scol--;


              $('.inSbN').removeClass('active');
            }
          },10);
        }
        if(i>0){
          setTimeout(function(){
            $('.inTx[name*="n_"]:eq('+(i-1)+')').focus();
          },10);
        }
      }
    });
  });

  $('.inTx[name*="check_"]').each(function(i){
    $(this).focusin(function(e) {
      $(this).val('')
    })
    $(this).keydown(function(chr){
      if((chr.keyCode<48||chr.keyCode>57)&&(chr.keyCode<96||chr.keyCode>105)&&chr.keyCode!=46&&chr.keyCode!=8){
        return false;
      } else if((chr.keyCode>=48&&chr.keyCode<=57)||(chr.keyCode>=96&&chr.keyCode<=105)) {
        setTimeout(function(){
          $('.inTx[name*="check_"]:eq('+(i+1)+')').focus()
        },10);
      } else if(chr.keyCode==8){
        setTimeout(function(){
          $('.inTx[name*="check_"]:eq('+(i-1)+')').focus()
        },10);
      }
    });
  });
  $('.inTp').each(function(i){
    $(this).keydown(function(chr){
      if((chr.keyCode<48||chr.keyCode>57)&&(chr.keyCode<96||chr.keyCode>105)&&chr.keyCode!=46&&chr.keyCode!=8){
        return false;
      } else if((chr.keyCode>=48&&chr.keyCode<=57)||(chr.keyCode>=96&&chr.keyCode<=105)) {
        setTimeout(function(){
          $('.inTp:eq('+(i+1)+')').focus()
        },10);
      } else if(chr.keyCode==8){
        setTimeout(function(){
          $('.inTp:eq('+(i-1)+')').focus()
        },10);
      }
    });
  });
  /*
  $('.inTx').each(function(i){
    $(this).keydown(function(chr){
      if((chr.keyCode<48||chr.keyCode>57)&&chr.keyCode!=46&&chr.keyCode!=8){
        return false;
      } else if((chr.keyCode>=48&&chr.keyCode<=57)) {
        setTimeout(function(){
          $('.inTx:eq('+(i+1)+')').focus()
        },10);
      } else if(chr.keyCode==8){
        setTimeout(function(){
          $('.inTx:eq('+(i-1)+')').focus()
        },10);
      }
    });
  });
*/
  $('.bigMnj .results ul').hide();
  var li_left=0;
  $('.tblNum50.hov li[class*=1],.tblNum50.hov li[class*=2],.tblNum50.hov li[class*=3],.tblNum50.hov li[class*=4],.tblNum50.hov li[class*=5],.tblNum50.hov li[class*=6],.tblNum50.hov li[class*=7],.tblNum50.hov li[class*=8],.tblNum50.hov li[class*=9],.tblNum50.hov li[class*=0]').mouseenter(function(){
    if($(this).index()>1){
      li_left=$(this).position().left+$(this).width()/2-53;
      rel = $(this).attr('rel');
      console.log(rel);
      $('.bigMnj .results').css({left:li_left+'px'}).show();
      $('.bigMnj .results ul[rel='+rel+']').show();
    }
  });
  $('.tblNum50.hov li[class*=1],.tblNum50.hov li[class*=2],.tblNum50.hov li[class*=3],.tblNum50.hov li[class*=4],.tblNum50.hov li[class*=5],.tblNum50.hov li[class*=6],.tblNum50.hov li[class*=7],.tblNum50.hov li[class*=8],.tblNum50.hov li[class*=9],.tblNum50.hov li[class*=0]').mouseleave(function(){
    if($(this).index()>1){
      $('.bigMnj .results').removeAttr('style').hide();
      $('.bigMnj .results ul').hide();
    }
  });

  /*var pval=10;
  $('.ordPoint .plus').click(function(){

    if(pval<500){
      pval+=10;
      $(this).parent().find('.orPIn').val(pval);
    }


    summ = pval*5
    $('.lOrdPoint .totPoin').text('баллов = '+summ+'р.');
    $('input[name="price"]').val(summ);
  });
  $('.ordPoint .minus').click(function(){
    pval-=10;
    if(pval==0) pval=10
    $(this).parent().find('.orPIn').val(pval);

    summ = pval*5
    $('.lOrdPoint .totPoin').text('баллов = '+summ+'р.');
    $('input[name="price"]').val(summ);

  });*/
  
  var pval=5;
  $('.ordPoint .plus').click(function(){

    if(pval<500){
      pval+=5;
      $(this).parent().find('.orPIn').val(pval);
    }


    summ = pval*5
    $('.lOrdPoint .totPoin').text('баллов = '+summ+'р.');
    $('input[name="price"]').val(summ);
  });
  $('.ordPoint .minus').click(function(){
    pval-=5;
    if(pval==0) pval=5
    $(this).parent().find('.orPIn').val(pval);

    summ = pval*5
    $('.lOrdPoint .totPoin').text('баллов = '+summ+'р.');
    $('input[name="price"]').val(summ);

  });

  /*TIMER-START*/
  if($('.time .start').text()>0){
    startTimer();
    console.log('start timer');
  } else {
    var time=$('.hidTime').html();
    if(typeof(time) != 'undefined'){

    m1=parseInt(time.charAt(0)),
    m2=parseInt(time.charAt(1)),
    s1=parseInt(time.charAt(3)),
    s2=parseInt(time.charAt(4)),

    $('.countBlockR .m1 div').addClass('bl-'+m1);
    $('.countBlockR .m2 div').addClass('bl-'+m2);

    $('.countBlockR .s1 div').addClass('bl-'+s1);
    $('.countBlockR .s2 div').addClass('bl-'+s2);
    }
  }
  /*TIMER-END*/

  function startTimer(){
  var time=$('.hidTime').html(),
  m1=parseInt(time.charAt(0)),
  m2=parseInt(time.charAt(1)),
  s1=parseInt(time.charAt(3)),
  s2=parseInt(time.charAt(4)),
  aTime=80;//время анимации

  $('.countBlockR .m1 div').addClass('bl-'+m1);
  $('.countBlockR .m2 div').addClass('bl-'+m2);

  $('.countBlockR .s1 div').addClass('bl-'+s1);
  $('.countBlockR .s2 div').addClass('bl-'+s2);

  $('.time').everyTime(60000,'timer',function(){
    s2--;
    if(s2<0){
      s2=9;
      s1--;
      if(s1<0){
        s1=5;
        m2--;
        if(m2<0){
          m2=9;
          m1--;
          if(m1<0){
            $('.time').stopTime('timer');
          }

          $('.countBlockR .m1 div').removeAttr('class');
          $('.countBlockR .m1 div').addClass('bl-'+m1);
        }

        $('.countBlockR .m2 div').removeAttr('class');
        $('.countBlockR .m2 div').addClass('bl-'+m2);
      }

      $('.countBlockR .s1 div').removeAttr('class');
      $('.countBlockR .s1 div').addClass('bl-'+s1);

    }

    $('.countBlockR .s2 div').removeAttr('class');
    $('.countBlockR .s2 div').addClass('bl-'+s2);

    if(m1==0&&m2==0&&s1==0&&s2==0) $('.time').stopTime('timer');
  });
}

});

function showpopup(id){
  var ht=0,st=0,wid=0;
  ht=$('#wrapper').height();
  $('#overlay').height(ht).show();
  ht=$('.popup#'+id).innerHeight()/2;
  wid=$('.popup#'+id).innerWidth()/2;
  st=$(window).scrollTop()-ht;
  $('.popup#'+id).css({'margin-top':st+'px','margin-left':'-'+wid+'px'}).show();
}
function showpopup2(obj,id){
  if(!$(obj).hasClass('activCb')){
    console.log(id);
    var ht=0,st=0,wid=0;
    $(obj).addClass('activCb');
    ht=$('#wrapper').height();
    $('#overlay').height(ht).show();
    ht=$('.popup#'+id).innerHeight()/2;
    wid=$('.popup#'+id).innerWidth()/2;
    st=$(window).scrollTop()-ht;
    $('.popup#'+id).css({'margin-top':st+'px','margin-left':'-'+wid+'px'}).show();
    return false;
  }
}

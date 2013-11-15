(function(){

	var doc = $(document);

	/*doc.on('change', function( e ){
		var q = $(e.target);
		if( q.attr("pattern") == undefined ) return;

		r = new RegExp(q.attr("pattern"),"i");

		var check = r.test( q.val() );

		if( !check && check != parseInt( q.attr('data-form-check') ) ){
			q.on( 'keyup', inp_check_again );
		}
		form_set_check( q, check );

		function inp_check_again(){
			if( r.test( q.val() ) ){
				form_set_check( q, true );
				q.off( 'keyup', inp_check_again );
			}
		}
	});

	doc.on('mousedown', function(e){
		var q = $(e.target);
		if( q.attr("data-rad") == undefined && q.attr("data-radi") == undefined ) return;

		q = q.prev();
		var check = !q.prop("checked");
		q.prop( "checked", check );

		form_set_check( q, check );
	});*/

	doc.on("mousedown", ".select", function(e){
		if( e.which != 1 ) return;

		var q = $(e.target);
		var p = $( this );
		var input = p.children(".select_input");
		var current = p.children(".select_current");

		if( current.prop('disabled') == true ) return false;

		if( current.is("input") && current.prop('readonly') == false && current.data("list_activated") == undefined ){
			current.data( "list_activated", true );

			var listki = p.children(".select_list").children();

			current.on( "keyup", function(){
				var regexp = new RegExp( current.val(),"i" );

				listki.each( function(){
					$(this).toggle( regexp.test( $(this).text() ) );
				});
			});

			current.on( "change", function(){
				var i = false;
				var regexp = new RegExp( "^"+current.val()+"$","i" );

				listki.each( function( index ){
					if( regexp.test( $(this).text() ) ){
						i = $( this );
						return false;
					}
				});

				listki.removeClass('on');

				if( i === false ){
					i = '';
					//form_set_check( input, false );
				} else {
					i.addClass('on');
					i = i.data("select");
					//form_set_check( input, true );
				}
				input.val( 'ads' );
				if( input != current ) input.trigger("change");
			});
		}

		if( q.data("select") != undefined ){
			if( current.is("input") ){
				current.val( q.text() ).trigger("change");
				
			} else {
				current.html( q.html() );
				input.val( q.data("select") ).trigger("change");
				//form_set_check( input, true );
			}

			if( current.data("list_activated") != true ) q.addClass("on").siblings().removeClass("on");
			p.removeClass('on');
		} else if( ! p.hasClass('on') ){
			p.addClass("on");
			var remon = ( current.is("input") && current.prop('readonly') == false ) ? [ current, "focusout" ] : [ doc, "mousedown" ];
			remon[0].one( remon[1], function(){ p.removeClass('on'); } );
		} else if( q.is( current ) ){
			return;
		}

		return current.is( "input" );
	});

	/*function isCheck( q ){
		return q.attr("data-form-check") === "1";
	}

	function form_set_check( q, check ){
		var listener_attr = "data-form-listener-"+q.attr('name');
		var listeners = $("["+listener_attr+"]");

		if( q.attr('type') === "radio" ){
			listeners.each( function(){
				var t = $(this);
				var bool = ( t.attr( listener_attr ) == q.val() && check );

				t.attr( "data-form-check", bool );
				t.find( "input[name!='"+q.attr('name')+"'], textarea" ).attr( "data-form-optional", !bool );
			});

			$("[data-radio='"+q.attr('name')+"']").attr( "data-form-check", check );
		} 
		else {
			q.add( listeners ).attr( "data-form-check", check );
		}
	}

	function listener( q, check ){
		var listeners = $("[data-form-listener-"+q.attr('name')+"]");
		if( ! listeners.length ) return;


		$("[data-form-listener='"+q.attr('name')+"']").attr( "data-form-check", false );
		q.closest("[data-form-listener='"+q.attr('name')+"']").attr( "data-form-check", check );
	}

	function formCheck( form ){
		var inputs = form.find("input[name], textarea");
		var bool = true;
		var q;
		inputs.each( function(){
			q = $(this);

			if( q.attr('data-form-optional') === "true" ) return true;

			if( q.attr('data-form-check') === "true" ) return true;

			if( q.attr('type') === "radio" ){
				q = $("[data-radio='"+q.attr('name')+"']");

				if( q.attr('data-form-check') === "true" ) return true;
			}

			alert( q.attr('data-form-alert') );
			bool = false;
			return false;
		});
		return bool;
	}

	doc.on("mousedown", "[data-form-submit]", function(e){
		var q = $(this);
		var f = q.closest('form');

		if( ! formCheck( f ) ) return;

		sendAjax(
			f.attr("method"),
			q,
			f.attr("action"),
			f.serialize(),
			f[0].respond
		);
	});

	function reloadFormReaction( data ){
		if( ! data.success ){
			alert( data.soob );
			return;
		}

		if( history.pushState ){
			aj.reload();
		} else {
			window.location.href = window.location.href;
		}
	}*/

})();

// ====================================================================
//  OneSpin Quantify MDV Controls
// ====================================================================

// --------------------------------------------------------------------
//  global variables
// --------------------------------------------------------------------

var gCtrlPanelVisible = false;
var gDebug = false;

var gFirstDetailedCtrlPanelVisible = true;
var gDetailedCtrlPanelVisible = false;
var gSimplifiedCtrlPanelVisible = false;
var gSimplifiedView = true;
var gToggleViewWhileCtrlPanelInVisible = false;
// summary numbers are calculated on page load, so we don't need
// to do this on and on again in onSelectionChanged()
var gSummaryNumbers = new Object();

gSummaryNumbers['covered_statement']      = 0;
gSummaryNumbers['reached_statement']    = 0;
gSummaryNumbers['unknown_statement']      = 0;
gSummaryNumbers['unobserved_statement']   = 0;
gSummaryNumbers['discovered_statement']   = 0;
gSummaryNumbers['constrained_statement']  = 0;
gSummaryNumbers['dead_statement']         = 0;
gSummaryNumbers['excluded_statement']     = 0;
gSummaryNumbers['redundant_statement']    = 0;
gSummaryNumbers['toolexcluded_statement']    = 0;
gSummaryNumbers['verification_statement'] = 0;

gSummaryNumbers['covered_branch']      = 0;
gSummaryNumbers['reached_branch']    = 0;
gSummaryNumbers['unknown_branch']      = 0;
gSummaryNumbers['unobserved_branch']   = 0;
gSummaryNumbers['discovered_branch']   = 0;
gSummaryNumbers['constrained_branch']  = 0;
gSummaryNumbers['dead_branch']         = 0;
gSummaryNumbers['excluded_branch']     = 0;
gSummaryNumbers['redundant_branch']    = 0;
gSummaryNumbers['toolexcluded_branch']    = 0;
gSummaryNumbers['verification_branch'] = 0;

var gLastTarget = 0;

//added for simplified control panel:
gSummaryNumbers['activated_statement']     = 0;
gSummaryNumbers['detected_statement']      = 0;
gSummaryNumbers['undetected_statement']   = 0;
gSummaryNumbers['open_statement']          = 0;
gSummaryNumbers['anyexcluded_statement']   = 0;

gSummaryNumbers['activated_branch']     = 0;
gSummaryNumbers['detected_branch']      = 0;
gSummaryNumbers['undetected_branch']   = 0;
gSummaryNumbers['open_branch']          = 0;
gSummaryNumbers['anyexcluded_branch']   = 0;

// --------------------------------------------------------------------
//  functions
// --------------------------------------------------------------------

function show_state(lable) {
  if (gDebug) {
        msg = "";
	msg +=  "*** " + lable + "\n";
	msg +=  "gSimplifiedView                    :=" + gSimplifiedView + "\n";
	msg +=  "gCtrlPanelVisible                  :=" + gCtrlPanelVisible + "\n";
	msg +=  "gFirstDetailedCtrlPanelVisible     :=" + gFirstDetailedCtrlPanelVisible + "\n";
	msg +=  "gDetailedCtrlPanelVisible          :=" + gDetailedCtrlPanelVisible + "\n";
	msg +=  "gSimplifiedCtrlPanelVisible        :=" + gSimplifiedCtrlPanelVisible + "\n";
	msg +=  "gToggleViewWhileCtrlPanelInVisible :=" + gToggleViewWhileCtrlPanelInVisible  + "\n";
        alert(msg);
  }
}

function getSumOfStatements()
{
	return ( gSummaryNumbers['covered_statement'] +
		 // gSummaryNumbers['activated_statement'] +
		 // gSummaryNumbers['detected_statement'] +
		 // gSummaryNumbers['undetected_statement'] +
		 // gSummaryNumbers['open_statement'] +
		 // gSummaryNumbers['anyexcluded_statement'] +
		 gSummaryNumbers['reached_statement'] +
		 gSummaryNumbers['unknown_statement'] +
		 gSummaryNumbers['unobserved_statement'] +
		 gSummaryNumbers['discovered_statement'] +
		 gSummaryNumbers['constrained_statement'] +
		 gSummaryNumbers['dead_statement'] +
		 gSummaryNumbers['excluded_statement'] +
		 gSummaryNumbers['redundant_statement'] +
		 gSummaryNumbers['toolexcluded_statement'] +
		 gSummaryNumbers['verification_statement'] );
}

function getSumOfBranches()
{
	return ( gSummaryNumbers['covered_branch'] +
		 // gSummaryNumbers['activated_branch'] +
		 // gSummaryNumbers['detected_branch'] +
		 // gSummaryNumbers['undetected_branch'] +
		 // gSummaryNumbers['open_branch'] +
		 // gSummaryNumbers['anyexcluded_branch'] +
		 gSummaryNumbers['reached_branch'] +
		 gSummaryNumbers['unknown_branch'] +
		 gSummaryNumbers['unobserved_branch'] +
		 gSummaryNumbers['discovered_branch'] +
		 gSummaryNumbers['constrained_branch'] +
		 gSummaryNumbers['dead_branch'] +
		 gSummaryNumbers['excluded_branch'] +
		 gSummaryNumbers['redundant_branch'] +
		 gSummaryNumbers['toolexcluded_branch'] +
		 gSummaryNumbers['verification_branch'] );
}

function toggleControlPanel() {
/* DEBUG*/
	show_state("invoking toggleControlPanel")

	var options = { direction: "right" };
	$("#control-panel").toggle( "slide", options, 500 );
	gCtrlPanelVisible = !gCtrlPanelVisible;
	if (gFirstDetailedCtrlPanelVisible) {

	  gFirstDetailedCtrlPanelVisible = false;
          gSimplifiedCtrlPanelVisible = true;
	  $("#simplified-control-panel").toggle( "slide", options, 100 );
	}
	if (gToggleViewWhileCtrlPanelInVisible) {
	  gToggleViewWhileCtrlPanelInVisible = false;
	  $("#detailed-control-panel").toggle( "slide", options, 100 );
	  $("#simplified-control-panel").toggle( "slide", options, 100 );
	}
	show_state("leaving toggleControlPanel");
}

function toggleSimplifiedView() {
  var toggle_c = document.getElementsByClassName("simplified_view");
  var toggle = document.getElementsByClassName("detailed_view");
  for (var i=0; i<toggle_c.length; i++) {
  if (toggle_c[i].style.display === "none") {
    gSimplifiedView = true
    if (toggle_c[i].tagName === "TR") {
		toggle_c[i].style.display = "table-row";
    } else {
		toggle_c[i].style.display = "table-cell";
    }
  } else {
    toggle_c[i].style.display = "none";
  }
  }
  
  for (var i=0; i<toggle.length; i++) {
  if (toggle_c[0].style.display === "none") {
    gSimplifiedView = false
    if (toggle[i].tagName === "TR") {
		toggle[i].style.display = "table-row";
	} else {
		toggle[i].style.display = "table-cell";
	}
  } else {
    toggle[i].style.display = "none";
  }
  }
}

function toggleDetailedControlPanel()
{
/* DEBUG*/
	show_state("invoking toggleDetailedControlPanel")
	var options = { direction: "right" };
	if (false && gFirstDetailedCtrlPanelVisible) {

	  gFirstDetailedCtrlPanelVisible = false;
          gSimplifiedCtrlPanelVisible = true;
	  $("#detailed-control-panel").toggle( "slide", options, 5000 );
	}

	if (gCtrlPanelVisible) {
	    $("#simplified-control-panel").toggle( "slide", options, 500 );
	    $("#detailed-control-panel").toggle( "slide", options, 500 );
	} else {
	    gToggleViewWhileCtrlPanelInVisible = !gToggleViewWhileCtrlPanelInVisible
	}
	gDetailedCtrlPanelVisible   = !gDetailedCtrlPanelVisible;
	gSimplifiedCtrlPanelVisible = !gSimplifiedCtrlPanelVisible;
	toggleSimplifiedView();
	show_state("leaving toggleDetailedControlPanel")
};

function ctrlButtonsReset()
{
	$('#goto_first').removeClass('ui-state-error');
	$('#goto_prev').removeClass('ui-state-error');
	$('#goto_next').removeClass('ui-state-error');
	$('#goto_last').removeClass('ui-state-error');
}

function ctrlButtonsError()
{
	$('#goto_first').addClass('ui-state-error');
	$('#goto_prev').addClass('ui-state-error');
	$('#goto_next').addClass('ui-state-error');
	$('#goto_last').addClass('ui-state-error');
}

function ctrlButtonsHighlight()
{
	$('#goto_first').addClass('ui-state-highlight');
	$('#goto_prev').addClass('ui-state-highlight');
	$('#goto_next').addClass('ui-state-highlight');
	$('#goto_last').addClass('ui-state-highlight');
}

function markerReset( node )
{
	if( node )
	{
		node.css( 'color', 'DarkSlateGrey' );
		node.css( 'backgroundColor', '#F7F7F7' );
	}
}

function markerHighlight( node )
{
	if( node )
	{
		node.css( 'color', 'White' );
		node.css( 'backgroundColor', 'Blue' );
	}
}

function findNextTarget( node_from, selection )
{
	var cur_tr = $('#source_code_table').children().first().children().first();
	if( node_from && node_from.length > 0 )
	{
		cur_tr = node_from.closest('tr').next();
	}
	var match = false;
	while( cur_tr.length > 0 )
	{
		if( selection.length < 1 )
		{
			break;
		}
		var content_node = cur_tr.children().last();
		for( var i = 0 ; i < selection.length ; ++i )
		{
			if( content_node.hasClass( selection[i] ) )
			{
				match = true;
				break;
			}
		}
		if( match )
		{
			break;
		}
		cur_tr = cur_tr.next();
	}
	return cur_tr.children().first();
}

function findPrevTarget( node_from, selection )
{
	var cur_tr = $('#source_code_table').children().first().children().last();
	if( node_from && node_from.length > 0 )
	{
		cur_tr = node_from.closest('tr').prev();
	}
	var match = false;
	while( cur_tr.length > 0 )
	{
		if( selection.length < 1 )
		{
			break;
		}
		var content_node = cur_tr.children().last();
		for ( var i = 0 ; i < selection.length ; ++i )
		{
			if( content_node.hasClass( selection[i] ) )
			{
				match = true;
				break;
			}
		}
		if( match )
		{
			break;
		}
		cur_tr = cur_tr.prev();
	}
	return cur_tr.children().first();
}

function scrollTo( node )
{
	if( node )
	{
		var tgt_line = node.text() - 10;
		if( tgt_line < 1 )
		{
			window.location.hash= ""; // top
		}
		else
		{
			window.location.hash= "#" + tgt_line;
		}
	}
}

function getSelection()
{
	var selection = new Array();
	if( $('#sel_st').is(':checked') )
	{
	  if (gDetailedCtrlPanelVisible)
	    {
		if( $('#st_1').is(':checked') )  { selection.push( 'covered_statement' ); }
		if( $('#st_R').is(':checked') )  { selection.push( 'reached_statement' ); }
		if( $('#st_U').is(':checked') )  { selection.push( 'unknown_statement' ); }
		if( $('#st_0R').is(':checked') ) { selection.push( 'unobserved_statement' ); }
		if( $('#st_0').is(':checked') )  { selection.push( 'discovered_statement' ); }
		if( $('#st_0c').is(':checked') ) { selection.push( 'constrained_statement' ); }
		if( $('#st_0d').is(':checked') ) { selection.push( 'dead_statement' ); }
		if( $('#st_Xu').is(':checked') ) { selection.push( 'excluded_statement' ); }
		if( $('#st_Xr').is(':checked') ) { selection.push( 'redundant_statement' ); }
		if( $('#st_Xt').is(':checked') ) { selection.push( 'toolexcluded_statement' ); }
		if( $('#st_Xv').is(':checked') ) { selection.push( 'verification_statement' ); }
	    } else {
		if( $('#st_D').is(':checked') )  { selection.push( 'detected_statement' ); }
		//if( $('#st_A').is(':checked') )  { selection.push( 'detected_statement' ); }
		if( $('#st_A').is(':checked') )  { selection.push( 'activated_statement' ); }
		if( $('#st_N').is(':checked') )  { selection.push( 'undetected_statement' ); }
		if( $('#st_O').is(':checked') )  { selection.push( 'open_statement' ); }
		if( $('#st_X').is(':checked') )  { selection.push( 'anyexcluded_statement' ); }
	    }
	}
	if( $('#sel_br').is(':checked') )
	{
	  if (gDetailedCtrlPanelVisible)
	    {
		if( $('#st_1').is(':checked') )  { selection.push( 'covered_branch' ); }
		if( $('#st_R').is(':checked') )  { selection.push( 'reached_branch' ); }
		if( $('#st_U').is(':checked') )  { selection.push( 'unknown_branch' ); }
		if( $('#st_0R').is(':checked') ) { selection.push( 'unobserved_branch' ); }
		if( $('#st_0').is(':checked') )  { selection.push( 'discovered_branch' ); }
		if( $('#st_0c').is(':checked') ) { selection.push( 'constrained_branch' ); }
		if( $('#st_0d').is(':checked') ) { selection.push( 'dead_branch' ); }
		if( $('#st_Xu').is(':checked') ) { selection.push( 'excluded_branch' ); }
		if( $('#st_Xr').is(':checked') ) { selection.push( 'redundant_branch' ); }
		if( $('#st_Xt').is(':checked') ) { selection.push( 'toolexcluded_branch' ); }
		if( $('#st_Xv').is(':checked') ) { selection.push( 'verification_branch' ); }
	    } else {
		// if( $('#st_A').is(':checked') )  { selection.push( 'detected_branch' ); }
		if( $('#st_A').is(':checked') )  { selection.push( 'activated_branch' ); }
		if( $('#st_D').is(':checked') )  { selection.push( 'detected_branch' ); }
		if( $('#st_N').is(':checked') )  { selection.push( 'undetected_branch' ); }
		if( $('#st_O').is(':checked') )  { selection.push( 'open_branch' ); }
		if( $('#st_X').is(':checked') )  { selection.push( 'anyexcluded_branch' ); }
	  }
	}
	return selection;
}

function checkPrimarySelection()
{
	// either 'statements' or 'branches' must be selected
	if( $('#sel_st').is(':checked') ||
		$('#sel_br').is(':checked') )
	{
		$('#sel_st_label').removeClass('ui-state-highlight');
		$('#sel_br_label').removeClass('ui-state-highlight');
		return true;
	}
	// else

	$('#sel_st_label').addClass('ui-state-highlight');
	$('#sel_br_label').addClass('ui-state-highlight');
	ctrlButtonsError();
	return false;
}

function checkSecondarySelection()
{
	// at least one of our classes must be selected
	if( $('#st_1').is(':checked') ||
		$('#st_R').is(':checked') ||
		$('#st_U').is(':checked') ||
		$('#st_0R').is(':checked') ||
		$('#st_0').is(':checked') ||
		$('#st_0c').is(':checked') ||
		$('#st_0d').is(':checked') ||
		$('#st_Xu').is(':checked') ||
		$('#st_Xr').is(':checked') ||
		$('#st_Xt').is(':checked') ||
		$('#st_Xv').is(':checked') ||
		$('#st_A').is(':checked') ||
		$('#st_D').is(':checked') ||
		$('#st_N').is(':checked') ||
		$('#st_O').is(':checked') ||
		$('#st_X').is(':checked')
        )
	{
		$('#st_1_label').removeClass('ui-state-highlight');
		$('#st_R_label').removeClass('ui-state-highlight');
		$('#st_U_label').removeClass('ui-state-highlight');
		$('#st_0R_label').removeClass('ui-state-highlight');
		$('#st_0_label').removeClass('ui-state-highlight');
		$('#st_0c_label').removeClass('ui-state-highlight');
		$('#st_0d_label').removeClass('ui-state-highlight');
		$('#st_Xu_label').removeClass('ui-state-highlight');
		$('#st_Xr_label').removeClass('ui-state-highlight');
		$('#st_Xt_label').removeClass('ui-state-highlight');
		$('#st_A_label').removeClass('ui-state-highlight');
		$('#st_D_label').removeClass('ui-state-highlight');
		$('#st_N_label').removeClass('ui-state-highlight');
		$('#st_O_label').removeClass('ui-state-highlight');
		$('#st_X_label').removeClass('ui-state-highlight');
		return true;
	}
	//else

	$('#st_1_label').addClass('ui-state-highlight');
	$('#st_R_label').addClass('ui-state-highlight');
	$('#st_U_label').addClass('ui-state-highlight');
	$('#st_0R_label').addClass('ui-state-highlight');
	$('#st_0_label').addClass('ui-state-highlight');
	$('#st_0c_label').addClass('ui-state-highlight');
	$('#st_0d_label').addClass('ui-state-highlight');
	$('#st_Xu_label').addClass('ui-state-highlight');
	$('#st_Xr_label').addClass('ui-state-highlight');
	$('#st_Xt_label').addClass('ui-state-highlight');
	$('#st_Xv_label').addClass('ui-state-highlight');
	$('#st_A_label').addClass('ui-state-highlight');
	$('#st_D_label').addClass('ui-state-highlight');
	$('#st_N_label').addClass('ui-state-highlight');
	$('#st_O_label').addClass('ui-state-highlight');
	$('#st_X_label').addClass('ui-state-highlight');
	ctrlButtonsError();
	return false;
}

function collectSummaryNumbers()
{
	for( var cla in gSummaryNumbers )
	{
		var search_id = "#summary_" + cla;
		var value = parseInt( $(search_id).text() );
		if( ! isNaN(value) )
		{
			gSummaryNumbers[cla] += value;
		}
	}

	/* DEBUG*/
	/*var msg = "";
	for( var cla in gSummaryNumbers )
	{
		msg += cla + "=" + gSummaryNumbers[cla] + "\n";
	}
	alert(msg);
	*/
}

function getNumberOfHits( selection )
{
	var sum = 0;
	for( var i = 0 ; i < selection.length ; ++i )
	{
		sum += gSummaryNumbers[ selection[i] ];
	}
	return sum;
}

function onSelectionChanged()
{
	ctrlButtonsReset();

	// either 'statements' or 'branches' must be selected
	var ok1 = checkPrimarySelection();

	// at least one of our classes must be selected
	var ok2 = checkSecondarySelection();

	// refresh buttons that may have changed their checked status
	$('#button_set_ctrl').buttonset("refresh");
	$('#button_set_st_br').buttonset("refresh");
	$('#button_set_1U0X').buttonset("refresh");
	
	if( !ok1 || !ok2 )
	{
		return;
	}

	// get current selection
	var selection = getSelection();

	if( selection.length > 0 )
	{
		//var first = findNextTarget( 0, selection );
		//if( first.length > 0 )
		if( getNumberOfHits(selection) > 0 )
		{
			ctrlButtonsReset();
		}
		else
		{
			ctrlButtonsError();
		}
	}
	else
	{
		ctrlButtonsError();
	}
}

function clearButton (b)
{
$(b).prop( "checked", false );
		$(b).button( "option", "disabled", true );
}
function initButton( b, t_s, t_b, d )
{
	if( gSummaryNumbers[t_s] + gSummaryNumbers[t_b]  == 0 )
	{
		$(b).prop( "checked", false );
		$(b).button( "option", "disabled", true );
	}
	else
	{
		$(b).prop( "checked", d );
		$(b).button( "option", "disabled", false );
	}
}

function gotoPrev()
{
	if( $('#goto_prev').hasClass('ui-state-error') )
	{
		return false;
	}
	ctrlButtonsReset();
	var selection = getSelection();
	var target = findPrevTarget( gLastTarget, selection );
	if( target.length > 0 )
	{
		markerReset( gLastTarget );
		markerHighlight( target );
		scrollTo( target );
		gLastTarget = target;
	}
	else
	{
		var first = findNextTarget( 0, selection );
		if( first.length > 0 )
		{
			$('#goto_prev').addClass('ui-state-error');
		}
		else
		{
			ctrlButtonsError();
		}
	}
	return false;
}

function gotoNext()
{
	if( $('#goto_next').hasClass('ui-state-error') )
	{
		return false;
	}
	ctrlButtonsReset();
	var selection = getSelection();
	var target = findNextTarget( gLastTarget, selection );
	if( target.length > 0 )
	{
		markerReset( gLastTarget );
		markerHighlight( target );
		scrollTo( target );
		gLastTarget = target;
	}
	else
	{
		var first = findNextTarget( 0, selection );
		if( first.length > 0 )
		{
			$('#goto_next').addClass('ui-state-error');
		}
		else
		{
			ctrlButtonsError();
		}
	}
	return false;
}

function toggleButton( b ) {
	$(b).prop( "checked", ! $(b).prop("checked") );
	onSelectionChanged();
}

$(document).keypress( function(event) {

	switch ( event.keyCode ) {
	case 37: gotoPrev(); break; // arrow-left
	case 38:             break; // arrow-up
	case 39: gotoNext(); break; // arrow-right
	case 40:             break; // arrow-down
	}

	switch ( event.which ) {
	case 32:  toggleControlPanel();    return false; // space
	case 49:  toggleButton('#st_1');   break; // 1
	case 50:  toggleButton('#st_U');   break; // 2
	case 117: toggleButton('#st_U');   break; // u
	case 51:  toggleButton('#st_0');   break; // 3
	case 48:  toggleButton('#st_0');   break; // 0
	case 52:  toggleButton('#st_0c');  break; // 4
	case 99:  toggleButton('#st_0c');  break; // c
	case 53:  toggleButton('#st_0d');  break; // 5
	case 100: toggleButton('#st_0d');  break; // d
	case 54:  toggleButton('#st_Xu');  break; // 6
	case 120: toggleButton('#st_Xu');  break; // x
	case 55:  toggleButton('#st_Xr');  break; // 7
	case 114: toggleButton('#st_Xr');  break; // r
	case 56:  toggleButton('#st_Xv');  break; // 8
	case 118: toggleButton('#st_Xv');  break; // v
	case 98:  toggleButton('#sel_br'); break; // b
	case 115: toggleButton('#sel_st'); break; // s
	}

});

$(document).ready( function() {

	// -------------------------------
	// create buttons and select icons
	// -------------------------------

	$('#show_control_panel').button({ text: false,
									  icons: {primary: "ui-icon-wrench"} });

	$('#hide_control_panel').button({ text: false,
										icons: {primary: "ui-icon-closethick"} });

	$('#home').button({ text: false,
						icons: {primary: "ui-icon-home"} });
	$('#switch_details').button({ text: false,
						icons: {primary: "ui-icon-search"} });

	$('#show_detailed_control_panel').button({ text: false,
						icons: {primary: "ui-icon-search"} });
	$('#hide_detailed_control_panel').button({ text: false,
						icons: {primary: "ui-icon-closethick"} });

	$('#goto_first').button({ text: false,
							  icons: {primary: "ui-icon-seek-start"} });
	//						  icons: {primary: "ui-icon-arrowthickstop-1-n"} });

	$('#goto_prev').button({ text: false,
							 icons: {primary: "ui-icon-seek-prev"} });
	//						 icons: {primary: "ui-icon-triangle-1-n"} });

	$('#goto_next').button({ text: false,
							 icons: {primary: "ui-icon-seek-next"} });
	//						 icons: {primary: "ui-icon-triangle-1-s"} });

	$('#goto_last').button({ text: false,
							 icons: {primary: "ui-icon-seek-end"} });
	//						 icons: {primary: "ui-icon-arrowthickstop-1-s"} });

	$('#button_set_ctrl').buttonset();
	$('#button_set_st_br').buttonset();
	$('#button_set_1U0X').buttonset();
	
	// -------------------------------
	// define click handlers
	// -------------------------------

	$('#show_control_panel').click( toggleControlPanel );
	$('#hide_control_panel').click( toggleControlPanel );

	$('#home').click( function()
	{
		markerReset( gLastTarget );
		gLastTarget = 0;
		window.location.hash= ""; // top
		return false;
	});

	$('#show_detailed_control_panel').click( toggleDetailedControlPanel );
	$('#hide_detailed_control_panel').click( toggleDetailedControlPanel );

	$('#goto_next').click( gotoNext );
    
	$('#goto_prev').click( gotoPrev );

	$('#goto_first').click( function()
	{
		if( $('#goto_first').hasClass('ui-state-error') )
		{
			return false;
		}
		ctrlButtonsReset();
		var target = findNextTarget( 0, getSelection() );
		if( target.length > 0 )
		{
			markerReset( gLastTarget );
			markerHighlight( target );
			scrollTo( target );
			gLastTarget = target;
			$('#goto_prev').addClass('ui-state-error');
		}
		else
		{
			ctrlButtonsError();
		}
		return false;
	});

	$('#goto_last').click( function()
	{
		if( $('#goto_last').hasClass('ui-state-error') )
		{
			return false;
		}
		ctrlButtonsReset();
		var target = findPrevTarget( 0, getSelection() );
		if( target.length > 0 )
		{
			markerReset( gLastTarget );
			markerHighlight( target );
			scrollTo( target );
			gLastTarget = target;
			$('#goto_next').addClass('ui-state-error');
		}
		else
		{
			ctrlButtonsError();
		}
		return false;
	});

	// react on selection changes
	$(':checkbox').click( function()
	{
		onSelectionChanged();
	});

	// collect summary numbers to speed up onSelectionChanged()
	collectSummaryNumbers();

	// disable buttons which we don't have statements for
	initButton( '#st_1', 'covered_statement', 'covered_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_R', 'reached_statement', 'reached_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_U', 'unknown_statement', 'unknown_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_0R', 'unobserved_statement', 'unobserved_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_0', 'discovered_statement', 'discovered_branch', true );
	initButton( '#st_0c', 'constrained_statement', 'constrained_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_0d', 'dead_statement', 'dead_branch', true );
	initButton( '#st_Xu', 'excluded_statement', 'excluded_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_Xr', 'redundant_statement', 'redundant_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_Xt', 'toolexcluded_statement', 'toolexcluded_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_Xv', 'verification_statement', 'verification_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_A', 'activated_statement', 'activated_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_D', 'detected_statement', 'detected_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_N', 'undetected_statement', 'undetected_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_O', 'open_statement', 'open_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	initButton( '#st_X', 'anyexcluded_statement', 'anyexcluded_branch', ( gSummaryNumbers['discovered_statement'] + gSummaryNumbers['dead_statement'] ) == 0 );
	if( getSumOfStatements() == 0 ) $('#sel_st').button( "option", "disabled", true );
	if( getSumOfBranches() == 0 )   $('#sel_br').button( "option", "disabled", true );

	// refresh buttons that may have changed their checked status
	$('#button_set_ctrl').buttonset("refresh");
	$('#button_set_st_br').buttonset("refresh");
	$('#button_set_1U0X').buttonset("refresh");
toggleDetailedControlPanel
 });

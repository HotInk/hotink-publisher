// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var load_button_fix = function () {
	if(Prototype.Browser.Gecko) $$('button').each(function(bt){bt.setStyle({marginLeft: "-3px", marginRight: "-3px"});});
}


/* Index page "card" functionality */

var Card = Class.create({
	initialize: function(element, selected) {
		this.element = $(element);
		this.document_link = this.element.select('.document_link')[0];
		this.delete_link = this.element.select('.delete_link')[0];
		this.selected = selected;
		this.element.card = this;
		this.checkbox = this.element.select('input[type="checkbox"]')[0];
		Event.observe(this.element, 'click', this.onclick.bindAsEventListener(this));
		Event.observe(this.element, 'mouseover', this.onmouseover.bindAsEventListener(this));	    
		Event.observe(this.element, 'mouseout', this.onmouseout.bindAsEventListener(this));	    
			    
	},
	
	onclick: function( e ) {
		var eventTarget = e.target ? e.target: e.srcElement;
    	skipped_elements = this.element.select('a, img');

		if (!skipped_elements.include(eventTarget)) {
			if (this.selected) {
				this.deselect();
			} else { 
				this.select();
			}
		}
	},
	
	select: function() {
		this.checkbox.checked = true;
		this.element.addClassName("selected_card");
		this.selected = true;
	},
	
	deselect: function() {
		this.checkbox.checked = null;
		this.element.removeClassName("selected_card");
		this.selected = false;
	},
	
	onmouseover: function() {
		this.element.addClassName('highlighted_card');
		this.delete_link.show();
	},
	
	onmouseout: function() {
		this.element.removeClassName('highlighted_card');
		this.delete_link.hide();
	}

});
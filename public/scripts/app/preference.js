function Select(args){
	this.el = $('#'+args.ID);
	this.eventName = args.eventName;
	// undefined if void.
	this.checkboxTemplate = $('#checkbox-template').html();
	this.initialize();
}

var selectMethods = {
	populate:function(data){
		
		data.forEach(function(e){
			this.el.
		});
	},

	setOption:function(option){
		this.el.selectAll('option').filter(function(d){return d.value==option})
								   .property('selected',true);
		this.onChange();
	},

	setOptionSilently:function(option){
		this.el.selectAll('option').filter(function(d){return d.value==option})
								   .property('selected',true);
	},

	setToNoneOptionSilently:function(){
		this.setOptionSilently(this.noneOption);
	},

	setToNoneOption:function(){
		this.setOption(this.noneOption);
	},

	initialize:function(){
		var self = this;
		_.bind(this.onChange,this);
		this.el.on("change",function(){
			self.onChange.apply(self);
		});
	},

	onChange:function(){
		var val = this.el.selectAll('option')
				.filter(function(){return d3.select(this).property("selected")})
				.property('value');
			if(this.noneOption&&(val==this.noneOption))
				this.trigger("noneOptionSelected");
			else
				this.trigger(this.eventName,val);
	}
}

_.extend(selectMethods,Backbone.Events);
_.extend(Select.prototype,selectMethods);
var submitButton = {
	source:'none',
	target:['none','none','none'],
	

	enable:function(){
		this.el.classed("pure-button-disabled",false);
	},

	initialize:function(args){
		this.updateTable = args.updateTable;
		this.updateChosenCount = args.updateChosenCount;
		this.el = d3.select('#submit');
		var self = this;
		this.el.on('click',function(){
			if(!self.el.classed("pure-button-disabled"))
			d3.text(document.URL+'submitPreference?source=' + self.source + '&target='+ JSON.stringify(self.target),function(res){
				console.log(res);
				self.updateTable();
				self.updateChosenCount();
			});
		});
	},

	disable:function(){
		this.el.classed("pure-button-disabled",true);
	},

	check:function(){
		var notNone = this.source!='none' && !_.contains(this.target,'none');
		var total = this.target.slice(0,this.target.length);
		total.push(this.source);
		var notEqual = _.uniq(total).length == 4;
		if(notNone && notEqual) this.enable();
		else this.disable();
	},

	updateStatus:function(i,val){
		if(i==3) this.source = val;
		else this.target[i] = val;
		this.check();
	},



}


_.extend(submitButton,Backbone.Events);
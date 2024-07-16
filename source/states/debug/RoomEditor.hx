package states.debug;

import backend.AssetPaths;
import backend.Global;
import backend.Rooms;
import backend.Script;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.FlxG;
import haxe.io.Path;
import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Label;
import haxe.ui.components.NumberStepper;
import haxe.ui.containers.ContinuousHBox;
import haxe.ui.containers.HBox;
import haxe.ui.containers.ListView;
import haxe.ui.containers.TabView;
import haxe.ui.containers.VBox;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.xml.Access;
import objects.room.Object;

class RoomEditor extends FlxTransitionableState
{
	var file:String;
	var data:Access;
	var script:Script;

	var chara:Object;
	var objects:FlxTypedGroup<Object>;

	var propertiesPage:ContinuousHBox;
	var instancesPage:ContinuousHBox;
	var ui:TabView;

	var camEditor:FlxCamera;
	var camHud:FlxCamera;

	override function create():Void
	{
		Rooms.reloadFiles();

		if (Rooms.data.exists(Global.room))
		{
			file = Rooms.data.get(Global.room).file;
			data = Rooms.data.get(Global.room).content;
		}

		persistentUpdate = true;

		script = new Script();
		script.set('this', this);
		script.execute(AssetPaths.script('rooms/$file'));

		camEditor = new FlxCamera();
		FlxG.cameras.reset(camEditor);

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camEditor, true);

		objects = new FlxTypedGroup<Object>();
		add(objects);

		if (data?.hasNode.instances)
		{
			final instances:Access = data.node.instances;

			for (instance in instances.nodes.instance)
			{
				switch (instance.att.objName)
				{
					case 'mainchara':
						chara = new Object(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y), instance.att.objName);

						// Make the sprite bigger.
						chara.scale.scale(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1,
							instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
						chara.updateHitbox();

						// Adjust the hitbox.
						chara.height *= 0.35;
						chara.centerOffsets();
						chara.centerOrigin();

						add(chara);
					default:
						var object:Object = new Object(Std.parseFloat(instance.att.x), Std.parseFloat(instance.att.y), instance.att.objName);
						object.scale.scale(instance.has.scaleX ? Std.parseFloat(instance.att.scaleX) : 1,
							instance.has.scaleY ? Std.parseFloat(instance.att.scaleY) : 1);
						object.updateHitbox();
						objects.add(object);
				}
			}
		}
		else
			FlxG.log.notice('There are no instances to load');

		ui = new TabView();
		ui.setPosition(0, 0);
		ui.setSize(300, 250);
		ui.camera = camHud;
		ui.draggable = false;
		ui.padding = 5;

		addTabs();
		addProperties();
		addInstances();

		add(ui);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		FlxG.watch.addQuick('Global room', Global.room);

		super.update(elapsed);
	}

	private inline function addTabs():Void
	{
		propertiesPage = new ContinuousHBox();
		propertiesPage.text = 'Properties';
		ui.addComponent(propertiesPage);

		if (data?.hasNode.instances)
		{
			instancesPage = new ContinuousHBox();
			instancesPage.text = 'Instances';
			ui.addComponent(instancesPage);
		}
	}

	private inline function addProperties():Void
	{
		if (propertiesPage == null)
			return;
		
		var vBox:VBox = new VBox();

		vBox.addComponent(createLabelAndNumberStepper('Room ID', 1000, 0, Global.room, function(event:UIEvent):Void
		{
			Global.room = Math.floor(cast(event.target, NumberStepper).pos);
		}));
		vBox.addComponent(createLabelAndNumberStepper('Room Width', Math.POSITIVE_INFINITY, 0, 640, function(event:UIEvent):Void
		{
			// Nothing for now
		}));
		vBox.addComponent(createLabelAndNumberStepper('Room Height', Math.POSITIVE_INFINITY, 0, 480, function(event:UIEvent):Void
		{
			// Nothing for now
		}));

		var checkBox:CheckBox = createCheckBox('Drag Editor', false);
		checkBox.onClick = function(event:MouseEvent):Void
		{
			ui.draggable = cast(event.target, CheckBox).selected;
		}
		vBox.addComponent(checkBox);

		var hBoxOptions:HBox = new HBox();

		for (option in ['Reset Room', 'Save Room'])
		{
			switch (option)
			{
				case 'Reset Room':
					var button:Button = createButton(option, 'darkred');
					button.onClick = (event:MouseEvent) -> FlxG.resetState();
					hBoxOptions.addComponent(button);
				case 'Save Room':
					var button:Button = createButton(option, 'green');
					button.onClick = (event:MouseEvent) -> FlxG.resetState();
					hBoxOptions.addComponent(button);
			}
		}

		vBox.addComponent(hBoxOptions);

		propertiesPage.addComponent(vBox);
	}

	private inline function addInstances():Void
	{
		if (instancesPage == null)
			return;

		var vBox:VBox = new VBox();

		var list:ListView = new ListView();
		list.setSize(200, 200);

		for (instance in data.node.instances.nodes.instance)
			list.dataSource.add(instance.att.objName);

		vBox.addComponent(list);

		instancesPage.addComponent(vBox);
	}

	private function createLabelAndNumberStepper(text:String, max:Float, min:Float, pos:Float, onChange:UIEvent->Void):HBox
	{
		var hBox:HBox = new HBox();

		var label:Label = new Label();
		label.text = text ?? 'Error!';
		label.verticalAlign = 'center';
		hBox.addComponent(label);

		var numberStepper:NumberStepper = new NumberStepper();
		numberStepper.max = max;
		numberStepper.min = min;
		numberStepper.pos = pos;

		if (onChange != null)
			numberStepper.onChange = onChange;

		hBox.addComponent(numberStepper);

		return hBox;
	}

	private function createButton(text:String, ?backgroundColor:String):Button
	{
		var button:Button = new Button();
		button.text = text ?? 'Error!';

		if (backgroundColor != null)
			button.backgroundColor = backgroundColor;

		return button;
	}

	private function createCheckBox(text:String, selected:Bool):CheckBox
	{
		var checkBox:CheckBox = new CheckBox();
		checkBox.text = text ?? 'Error!';
		checkBox.selected = selected;
		return checkBox;
	}
}

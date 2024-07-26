package utf.substates.battle;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import utf.backend.AssetPaths;
import utf.input.Controls;
import utf.backend.Data;
import utf.backend.Global;
import utf.objects.battle.Monster;
import utf.backend.registries.MonsterRegistry;
import utf.objects.dialogue.Writer;
import utf.substates.GameOver;

class EnemyEncounter extends FlxSubState
{
	var selected:Int = 0;
	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
	var items:FlxTypedGroup<FlxSprite>;

	public var bg:FlxSprite;
	public var stats:FlxText;
	public var hpName:FlxSprite;
	public var hpBar:FlxBar;
	public var hpInfo:FlxText;

	public var monster:Monster;
	public var box:FlxShapeBox;
	public var heart:FlxSprite;
	public var writer:Writer;

	var bullets:FlxTypedGroup<FlxSprite>;

	override function create():Void
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		bg.active = false;
		add(bg);

		stats = new FlxText(30, 400, 0, Global.name + '   LV ' + Global.lv, 22);
		stats.font = AssetPaths.font('Small');
		stats.scrollFactor.set();
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, AssetPaths.sprite('hpname'));
		hpName.scrollFactor.set();
		hpName.active = false;
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, 'hp', 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.emptyCallback = () -> openSubState(new GameOver());
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + hpBar.width, hpBar.y, 0, '${Global.hp} / ${Global.maxHp}', 22);
		hpInfo.font = AssetPaths.font('Small');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		items = new FlxTypedGroup<FlxSprite>();

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32);
			bt.frames = AssetPaths.spritesheet(choices[i].toLowerCase() + 'bt');
			bt.animation.frameIndex = 1;

			switch (choices[i])
			{
				case 'Fight':
					bt.x = 32;
				case 'Talk':
					bt.x = 185;
				case 'Item':
					bt.x = 345;
				case 'Spare':
					bt.x = 500;
			}

			bt.scrollFactor.set();
			bt.ID = i;
			items.add(bt);
		}

		add(items);

		monster = MonsterRegistry.fetchMonster('undyne-ex');
		monster.scrollFactor.set();
		add(monster);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		heart = new FlxSprite(0, 0, AssetPaths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		add(heart);

		writer = new Writer(box.x + 14, box.y + 14);
		writer.skippable = false;
		writer.startDialogue([
			{typer: 'battle', text: FlxG.random.getObject(monster.monsterComments)}
		]);
		writer.scrollFactor.set();
		add(writer);

		bullets = new FlxTypedGroup<FlxSprite>();
		add(bullets);

		changeChoice();

		super.create();
	}

	var choiceSelected:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (Controls.justPressed('right') && !choiceSelected)
			changeChoice(1);
		else if (Controls.justPressed('left') && !choiceSelected)
			changeChoice(-1);

		if (Controls.justPressed('confirm'))
		{
			FlxG.sound.play(AssetPaths.sound('menuconfirm'));

			if (choiceSelected)
			{
				if (choices[selected] == 'Talk')
				{
					// TODO
				}
				else
				{
					writer.visible = false;

					// TODO
				}
			}
			else
			{
				writer.visible = true;

				if (choices[selected] == 'Item' && Global.items.length <= 0)
					return;

				choiceSelected = true;

				switch (choices[selected])
				{
					case 'Fight' | 'Talk':
						writer.startDialogue([
							{typer: 'battle', text: '* ${monster.monsterName}'}
						]);

						/*var monsterHpBar:FlxBar = new FlxBar(box.x + 158 + (monster.monsterName.length * 16), writer.y, LEFT_TO_RIGHT,
							Std.int(monster.monsterHp / monster.monsterMaxHp * 100), 16, monster, 'monsterHp', 0, monster.monsterMaxHp);
						monsterHpBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
						monsterHpBar.emptyCallback = () -> FlxG.log.notice('YOU WON!');
						monsterHpBar.scrollFactor.set();
						add(monsterHpBar);*/
					case 'Item':
						writer.startDialogue([
							{typer: 'battle', text: '* Item Selected...'}
						]);
					case 'Spare':
						writer.startDialogue([
							{typer: 'battle', text: '* Mercy Selected...'}
						]);
				}
			}
		}
		else if (Controls.justPressed('cancel'))
		{
			choiceSelected = false;

			writer.visible = true;

			writer.startDialogue([
				{typer: 'battle', text: '* You feel like you\'re going to\n  have a bad time.'}
			]);
		}

		#if debug
		if (FlxG.keys.justPressed.G)
			Global.hp = 0;
		#end

		super.update(elapsed);

		if (hpInfo != null)
		{
			final hpInfoText:String = '${Global.hp} / ${Global.maxHp}';

			if (hpInfo.text != hpInfoText)
				hpInfo.text = hpInfoText;
		}
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(AssetPaths.sound('menumove'));

		selected = FlxMath.wrap(selected + num, 0, choices.length - 1);

		items.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == selected)
			{
				spr.animation.frameIndex = 0;

				heart.setPosition(spr.x + 8, spr.y + 14);
			}
			else
				spr.animation.frameIndex = 1;
		});
	}
}

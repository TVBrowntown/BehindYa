<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <UiMod name="BehindYa" version="2.4.4" date="13/08/2020" >

	<Author name="Squibblegut" email="" />
	<Description text="Behind Ya! The Crit Rate display of that one important ability." />
	<VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.0" />
	<Dependencies>
	</Dependencies>

	<Files>
		<File name="BehindYa.lua" />
		<File name="BehindYa.xml" />
		<File name="TargetInfoFix.lua" />
	</Files>

	<OnInitialize>
		<CallFunction name="BehindYa.onInit" />
	</OnInitialize>
	<OnUpdate>
    </OnUpdate>
	<SavedVariables>
		<SavedVariable name="BehindYa.enabled"/>
	</SavedVariables>
		<WARInfo>
			<Categories>
				<Category name="COMBAT" />
			</Categories>
			<Careers>
				<Career name="SQUIG_HERDER" />
			</Careers>
		</WARInfo>
	</UiMod>
</ModuleFile>

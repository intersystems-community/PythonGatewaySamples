/// Installer for the container release of PythonGatewaySamples
Class ml.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Default Name="NAMESPACE" Value="PYTHON"/>
  <Default Name="SOURCESPATH" Dir='#{$system.Util.GetEnviron("SRC_DIR")}' />
  <Namespace Name="${NAMESPACE}" Create="no">
    <!--<Import File="${SOURCESPATH}ml" Recurse="1"/>-->
    
    <Log Level="1" Text="Configuring Production"/>
    <Invoke Class="ml.Installer" Method="ConfigureProduction" CheckStatus="true"/>
    <Invoke Class="ml.Installer" Method="CreateWebApp" CheckStatus="true"/>
    <Invoke Class="ml.cam.data.Photo" Method="LoadDir" CheckStatus="true">
    <Arg Value='#{$system.Util.GetEnviron("PHOTO_DIR")}'/>
    </Invoke>
  </Namespace>
</Manifest>
}

ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Set production as default. 
/// Set production category to Engine
/// Autostart production
/// Make PYTHON Analytics enabled namespace
/// do ##class(ml.Installer).ConfigureProduction()
ClassMethod ConfigureProduction() As %Status
{
	#dim sc As %Status = $$$OK
	set production = "ml.Production"
	set ^Ens.Configuration("csp","LastProduction") = production
	
	for user = "UnknownUser", "Admin", "SuperUser", "_SYSTEM" {
		set ^EnsPortal.Settings(user, "PreferredCategory", production)="Engine"
	}
	
	$$$QuitOnError(##class(Ens.Director).SetAutoStart(production))
	
	set app = "/csp/python/"
	do EnableDeepSee^%SYS.cspServer(app)
	do EnableIKnow^%SYS.cspServer(app)
	
	set sc = ..ConfigureProcess()
	
	quit sc
}

/// Save TrainProcess Data to /csp/user directory
ClassMethod ConfigureProcess() As %Status
{
	#dim sc As %Status = $$$OK
	set production = "ml.Production"
	set process = "ml.engine.TrainProcess"
	
	set setting = ##class(Ens.Config.Setting).%New()
	set setting.Name = "WorkDirectory"
	set setting.Target = "Host"
	set setting.Value = ##class(%File).SubDirectoryName(##class(%File).SubDirectoryName($System.Util.InstallDirectory(),"csp", 1), "user", 1)


	set exists = ##class(Ens.Config.Item).NameExists(production, process, .itemId)
	set item =  ##class(Ens.Config.Item).%OpenId(itemId)
	do item.Settings.Insert(setting)
	set sc = item.%Save()	
	quit sc
}

/// Create /cam web app
ClassMethod CreateWebApp()
{
	new $namespace
	set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
	set cspProperties("NameSpace") = $namespace
	set cspProperties("IsNameSpaceDefault") = $$$YES
	set cspProperties("DispatchClass") =  "ml.cam.rest.Main"
	
	set $namespace = "%SYS"
	set sc = ##class(Security.Applications).Create("/cam", .cspProperties)
	quit sc
}

}


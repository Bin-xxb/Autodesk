<#-- Build the options variable -->
<#assign modalOptions = modalsupport.options
    .setButtonType("primary")
    .setTitle("custom-modal.test.title")
    .setSmall(true).setResizable(false)
    .setWidth(20)
    .setMaxHeight(20)
.build />

<#-- Build the parameters variable -->
<#assign componentParameters = modalsupport.component.parameters.add("name", "1").add("panel", "true").build />

<#-- Call the modal directive passing the variables -->
<@modal id="autodesk-custom-group-join-requirements" label="custom-modal-group-request-join.label.key" parameters=componentParameters options=modalOptions />
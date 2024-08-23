<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
//$routes->get('/', 'Home::index');
$routes->add("/", 'DefaultController::index');
$routes->add('default', 'DefaultController::index');
$routes->add('dbstructureHtml', '\Ppci\Controllers\Miscellaneous::structureHtml');
$routes->add('dbstructureLatex', '\Ppci\Controllers\Miscellaneous::structureLatex');
$routes->add('dbstructureSchema', '\Ppci\Controllers\Miscellaneous::structureSchema');
$routes->add('lexique', 'Lexique::index');
$routes->add('eventTypeList', 'EventType::list');
$routes->add('eventTypeChange', 'EventType::change');
$routes->post('eventTypeWrite', 'EventType::write');
$routes->post('eventTypeDelete', 'EventType::delete');
$routes->add('eventTypeGetAjax', 'EventType::getAjax');
$routes->add('containerFamilyList', 'ContainerFamily::list');
$routes->add('containerFamilyChange', 'ContainerFamily::change');
$routes->post('containerFamilyWrite', 'ContainerFamily::write');
$routes->post('containerFamilyDelete', 'ContainerFamily::delete');
$routes->add('objectStatusList', 'ObjectStatus::list');
$routes->add('objectStatusChange', 'ObjectStatus::change');
$routes->post('objectStatusWrite', 'ObjectStatus::write');
$routes->add('storageConditionList', 'StorageCondition::list');
$routes->add('storageConditionChange', 'StorageCondition::change');
$routes->post('storageConditionWrite', 'StorageCondition::write');
$routes->post('storageConditionDelete', 'StorageCondition::delete');
$routes->add('containerTypeList', 'ContainerType::list');
$routes->add('containerTypeChange', 'ContainerType::change');
$routes->post('containerTypeWrite', 'ContainerType::write');
$routes->post('containerTypeDelete', 'ContainerType::delete');
$routes->add('containerTypeGetFromFamily', 'ContainerType::getFromFamily');
$routes->add('containerTypeGetListAjax', 'ContainerType::listAjax');
$routes->add('sampleTypeList', 'SampleType::list');
$routes->add('sampleTypeChange', 'SampleType::change');
$routes->post('sampleTypeWrite', 'SampleType::write');
$routes->post('sampleTypeDelete', 'SampleType::delete');
$routes->add('sampleTypeMetadata', 'SampleType::metadata');
$routes->add('sampleTypeMetadataSearchable', 'SampleType::metadataSearchable');
$routes->add('sampleTypeGenerator', 'SampleType::generator');
$routes->add('sampleTypeGetListAjax', 'SampleType::getListAjax');
$routes->add('movementReasonList', 'MovementReason::list');
$routes->add('movementReasonChange', 'MovementReason::change');
$routes->post('movementReasonWrite', 'MovementReason::write');
$routes->post('movementReasonDelete', 'MovementReason::delete');
$routes->add('dbparamList', '\Ppci\Controllers\Dbparam::list');
$routes->add('dbparamWriteGlobal', '\Ppci\Controllers\Dbparam::writeGlobal');
$routes->add('referentList', 'Referent::list');
$routes->add('referentChange', 'Referent::change');
$routes->post('referentWrite', 'Referent::write');
$routes->post('referentDelete', 'Referent::delete');
$routes->add('referentGetFromName', 'Referent::getFromName');
$routes->add('referentGetFromId', 'Referent::getFromId');
$routes->add('referentCopy', 'Referent::copy');
$routes->add('containerList', 'Container::list');
$routes->add('containerDisplay', 'Container::display');
$routes->add('containerChange', 'Container::change');
$routes->post('containerWrite', 'Container::write');
$routes->post('containerDelete', 'Container::delete');
$routes->add('containerGetChildren', 'Container::getChildren');
$routes->add('containerGetFromType', 'Container::getFromType');
$routes->add('containerGetFromUid', 'Container::getFromUid');
$routes->add('containerGetOccupation', 'Container::getOccupationAjax');
$routes->add('containerImportStage1', 'Container::importStage1');
$routes->add('containerImportStage2', 'Container::importStage2');
$routes->add('containerImportStage3', 'Container::importStage3');
$routes->add('containersLending', 'Container::lendingMulti');
$routes->add('containersExit', 'Container::exitMulti');
$routes->add('containersDelete', 'Container::deleteMulti');
$routes->add('containersSetStatus', 'Container::setStatus');
$routes->add('containersEntry', 'Container::entryMulti');
$routes->add('containersSetTrashed', 'Object::setTrashed');
$routes->add('containersSetReferent', 'Container::referentMulti');
$routes->add('containersSetCollection', 'Container::setCollection');
$routes->add('containerVerifyCyclic', 'Container::verifyCyclic');
$routes->add('containerVerifyCyclicExec', 'Container::verifyCyclicExec');
$routes->add('containereventChange', 'Event::change');
$routes->add('containereventDisplay', 'Event::display');
$routes->post('containereventWrite', 'Event::write');
$routes->post('containereventDelete', 'Event::delete');
$routes->add('sampleeventChange', 'Event::change');
$routes->add('sampleeventDisplay', 'Event::display');
$routes->post('sampleeventWrite', 'Event::write');
$routes->post('sampleeventDelete', 'Event::delete');
$routes->add('eventSearch', 'Event::search');
$routes->add('eventsDelete', 'Event::deleteList');
$routes->add('eventsChange', 'Event::changeList');
$routes->post('eventSearcheventWrite', 'Event::write');
$routes->post('eventSearcheventDelete', 'Event::delete');
$routes->add('movementcontainerInput', 'Movement::input');
$routes->add('movementcontainerOutput', 'Movement::output');
$routes->post('movementcontainerWrite', 'Movement::write');
$routes->post('movementcontainerDelete', 'Movement::delete');
$routes->add('movementInput', 'Movement::input');
$routes->add('movementsampleInput', 'Movement::input');
$routes->add('movementsampleOutput', 'Movement::output');
$routes->post('movementsampleWrite', 'Movement::write');
$routes->post('movementsampleDelete', 'Movement::delete');
$routes->add('collectionList', 'Collection::list');
$routes->add('collectionChange', 'Collection::change');
$routes->post('collectionWrite', 'Collection::write');
$routes->post('collectionDelete', 'Collection::delete');
$routes->add('collectionGet', 'Collection::getAjax');
$routes->add('collectionsGenerateMail', 'Collection::generateMails');
$routes->add('regulationList', 'Regulation::list');
$routes->add('regulationChange', 'Regulation::change');
$routes->post('regulationWrite', 'Regulation::write');
$routes->post('regulationDelete', 'Regulation::delete');
$routes->add('campaignList', 'Campaign::list');
$routes->add('campaignChange', 'Campaign::change');
$routes->add('campaignDisplay', 'Campaign::display');
$routes->post('campaignWrite', 'Campaign::write');
$routes->post('campaignDelete', 'Campaign::delete');
$routes->add('campaignImport', 'Campaign::import');
$routes->add('campaignRegulationChange', 'CampaignRegulation::change');
$routes->post('campaignRegulationWrite', 'CampaignRegulation::write');
$routes->post('campaignRegulationDelete', 'CampaignRegulation::delete');
$routes->add('labelList', 'Label::list');
$routes->add('labelChange', 'Label::change');
$routes->post('labelWrite', 'Label::write');
$routes->post('labelWriteStay', 'Label::writeStay');
$routes->post('labelDelete', 'Label::delete');
$routes->add('labelCopy', 'Label::copy');
$routes->add('metadataFormGetDetail', 'SampleType::getDetailFormAjax');
$routes->add('sampleList', 'Sample::list');
$routes->add('sampleSearchAjax', 'Sample::searchAjax');
$routes->add('sampleGetFromIdAjax', 'Sample::getFromId');
$routes->add('sampleDisplay', 'Sample::display');
$routes->add('sampleChange', 'Sample::change');
$routes->post('sampleWrite', 'Sample::write');
$routes->post('sampleDelete', 'Sample::delete');
$routes->add('sampleExport', 'Sample::export');
$routes->add('sampleImportStage1', 'Sample::importStage1');
$routes->add('sampleImportStage2', 'Sample::importStage2');
$routes->add('sampleImportStage3', 'Import::importExterneExec');
$routes->add('switch', 'Switch::index');
$routes->add('samplesDelete', 'Sample::deleteMulti');
$routes->add('samplesAssignReferent', 'Sample::referentAssignMulti');
$routes->add('samplesCreateEvent', 'Sample::eventAssignMulti');
$routes->add('samplesLending', 'Sample::lendingMulti');
$routes->add('sampleDetail', 'SampleWs::detail');
$routes->add('samplesSetTrashed', 'Object::setTrashed');
$routes->add('samplesExit', 'Sample::exitMulti');
$routes->add('samplesEntry', 'Sample::entryMulti');
$routes->add('samplesSetCountry', 'Sample::setCountry');
$routes->add('samplesSetCollection', 'Sample::setCollection');
$routes->add('samplesSetCampaign', 'Sample::setCampaign');
$routes->add('samplesSetStatus', 'Sample::setStatus');
$routes->add('samplesSetParent', 'Sample::setParent');
$routes->add('sampleGetChildren', 'Sample::getChildren');
$routes->add('movementList', 'Movement::list');
$routes->add('fastInputChange', 'Movement::fastInputChange');
$routes->add('fastInputWrite', 'Movement::fastInputWrite');
$routes->add('fastOutputChange', 'Movement::fastOutputChange');
$routes->add('fastOutputWrite', 'Movement::fastOutputWrite');
$routes->add('objectGetLastEntry', 'Movement::getLastEntry');
$routes->add('smallMovementChange', 'Movement::smallMovementChange');
$routes->add('smallMovementWrite', 'Movement::smallMovementWrite');
$routes->add('smallMovementWriteAjax', 'Movement::smallMovementWriteAjax');
$routes->add('objectGetDetail', 'Object::getDetailAjax');
$routes->add('containerPrintLabel', 'Object::printLabel');
$routes->add('containerExportCSV', 'Object::exportCSV');
$routes->add('containerExportGlobal', 'Container::exportGlobal');
$routes->add('containerPrintDirect', 'Object::printLabelDirect');
$routes->add('samplePrintLabel', 'Object::printLabel');
$routes->add('sampleExportCSV', 'Object::exportCSV');
$routes->add('samplePrintDirect', 'Object::printLabelDirect');
$routes->add('importChange', 'Import::change');
$routes->add('importControl', 'Import::control');
$routes->add('importImport', 'Import::import');
$routes->add('containerbookingChange', 'Booking::change');
$routes->post('containerbookingWrite', 'Booking::write');
$routes->post('containerbookingDelete', 'Booking::delete');
$routes->add('samplebookingChange', 'Booking::change');
$routes->post('samplebookingWrite', 'Booking::write');
$routes->post('samplebookingDelete', 'Booking::delete');
$routes->add('bookingVerifyInterval', 'Booking::verifyInterval');
$routes->add('protocolList', 'Protocol::list');
$routes->add('protocolChange', 'Protocol::change');
$routes->post('protocolWrite', 'Protocol::write');
$routes->post('protocolDelete', 'Protocol::delete');
$routes->add('protocolFile', 'Protocol::file');
$routes->add('operationList', 'Operation::list');
$routes->add('operationChange', 'Operation::change');
$routes->add('operationCopy', 'Operation::copy');
$routes->post('operationWrite', 'Operation::write');
$routes->post('operationDelete', 'Operation::delete');
$routes->add('multipleTypeList', 'MultipleType::list');
$routes->add('multipleTypeChange', 'MultipleType::change');
$routes->post('multipleTypeWrite', 'MultipleType::write');
$routes->post('multipleTypeDelete', 'MultipleType::delete');
$routes->add('samplingPlaceList', 'SamplingPlace::list');
$routes->add('samplingPlaceChange', 'SamplingPlace::change');
$routes->post('samplingPlaceWrite', 'SamplingPlace::write');
$routes->post('samplingPlaceDelete', 'SamplingPlace::delete');
$routes->add('samplingPlaceImport', 'SamplingPlace::import');
$routes->add('samplingPlaceGetFromCollection', 'SamplingPlace::getFromCollection');
$routes->add('samplingPlaceGetCoordinate', 'SamplingPlace::getCoordinate');
$routes->add('countryList', 'Country::list');
$routes->add('subsampleChange', 'Subsample::change');
$routes->post('subsampleWrite', 'Subsample::write');
$routes->post('subsampleDelete', 'Subsample::delete');
$routes->post('containerdocumentWrite', 'Document::write');
$routes->post('containerdocumentDelete', 'Document::delete');
$routes->post('sampledocumentWrite', 'Document::write');
$routes->post('sampledocumentDelete', 'Document::delete');
$routes->post('samplesDocument', 'Document::write');
$routes->post('campaigndocumentWrite', 'Document::write');
$routes->post('campaigndocumentDelete', 'Document::delete');
$routes->post('sampleeventdocumentWrite', 'Document::write');
$routes->post('sampleeventdocumentDelete', 'Document::delete');
$routes->post('containereventdocumentWrite', 'Document::write');
$routes->post('containereventdocumentDelete', 'Document::delete');
$routes->add('documentGet', 'Document::get');
$routes->add('documentGetSW', 'Document::getSW');
$routes->add('documentGetSWerror', 'Document::getSWerror');
$routes->add('documentExternalGetList', 'Document::externalGetList');
$routes->add('documentExternalAdd', 'Document::externalAdd');
$routes->add('documentGetExternal', 'Document::getExternal');
$routes->add('identifierTypeList', 'IdentifierType::list');
$routes->add('identifierTypeChange', 'IdentifierType::change');
$routes->post('identifierTypeWrite', 'IdentifierType::write');
$routes->post('identifierTypeDelete', 'IdentifierType::delete');
$routes->add('containerobjectIdentifierChange', 'ObjectIdentifier::change');
$routes->post('containerobjectIdentifierWrite', 'ObjectIdentifier::write');
$routes->post('containerobjectIdentifierDelete', 'ObjectIdentifier::delete');
$routes->add('sampleobjectIdentifierChange', 'ObjectIdentifier::change');
$routes->post('sampleobjectIdentifierWrite', 'ObjectIdentifier::write');
$routes->post('sampleobjectIdentifierDelete', 'ObjectIdentifier::delete');
$routes->add('movementBatchOpen', 'Movement::batchOpen');
$routes->add('movementBatchRead', 'Movement::batchRead');
$routes->add('movementBatchWrite', 'Movement::batchWrite');
$routes->add('printerList', 'Printer::list');
$routes->add('printerChange', 'Printer::change');
$routes->post('printerWrite', 'Printer::write');
$routes->post('printerDelete', 'Printer::delete');
$routes->add('metadataList', 'Metadata::list');
$routes->add('metadataDisplay', 'Metadata::display');
$routes->add('metadataChange', 'Metadata::change');
$routes->post('metadataWrite', 'Metadata::write');
$routes->post('metadataDelete', 'Metadata::delete');
$routes->add('metadataCopy', 'Metadata::copy');
$routes->add('metadataGetschema', 'Metadata::getSchema');
$routes->add('metadataExport', 'Metadata::export');
$routes->add('metadataImport', 'Metadata::import');
$routes->add('borrowerList', 'Borrower::list');
$routes->add('borrowerDisplay', 'Borrower::display');
$routes->add('borrowerChange', 'Borrower::change');
$routes->post('borrowerWrite', 'Borrower::write');
$routes->post('borrowerDelete', 'Borrower::delete');
$routes->add('sampleborrowingChange', 'Borrowing::change');
$routes->post('sampleborrowingWrite', 'Borrowing::write');
$routes->post('sampleborrowingDelete', 'Borrowing::delete');
$routes->add('containerborrowingChange', 'Borrowing::change');
$routes->post('containerborrowingWrite', 'Borrowing::write');
$routes->post('containerborrowingDelete', 'Borrowing::delete');
$routes->add('exportModelList', 'ExportModel::list');
$routes->add('exportModelDisplay', 'ExportModel::display');
$routes->add('exportModelChange', 'ExportModel::change');
$routes->post('exportModelWrite', 'ExportModel::write');
$routes->post('exportModelDelete', 'ExportModel::delete');
$routes->add('exportModelDuplicate', 'ExportModel::duplicate');
$routes->add('exportModelExec', 'ExportModelProcessing::exec');
$routes->add('exportModelImportExec', 'ExportModelProcessing::importExec');
$routes->add('mimeTypeList', 'MimeType::list');
$routes->add('mimeTypeChange', 'MimeType::change');
$routes->post('mimeTypeWrite', 'MimeType::write');
$routes->post('mimeTypeDelete', 'MimeType::delete');
$routes->add('licenseList', 'License::list');
$routes->add('licenseChange', 'License::change');
$routes->post('licenseWrite', 'License::write');
$routes->post('licenseDelete', 'License::delete');
$routes->add('datasetTypeList', 'DatasetType::list');
$routes->add('datasetTypeChange', 'DatasetType::change');
$routes->post('datasetTypeWrite', 'DatasetType::write');
$routes->post('datasetTypeDelete', 'DatasetType::delete');
$routes->add('datasetTemplateList', 'DatasetTemplate::list');
$routes->add('datasetTemplateDisplay', 'DatasetTemplate::display');
$routes->add('datasetTemplateChange', 'DatasetTemplate::change');
$routes->post('datasetTemplateWrite', 'DatasetTemplate::write');
$routes->post('datasetTemplateDelete', 'DatasetTemplate::delete');
$routes->add('datasetTemplateDuplicate', 'DatasetTemplate::duplicate');
$routes->add('datasetColumnChange', 'DatasetColumn::change');
$routes->post('datasetColumnWrite', 'DatasetColumn::write');
$routes->post('datasetColumnDelete', 'DatasetColumn::delete');
$routes->add('translatorList', 'Translator::list');
$routes->add('translatorChange', 'Translator::change');
$routes->post('translatorWrite', 'Translator::write');
$routes->post('translatorDelete', 'Translator::delete');
$routes->add('exportTemplateList', 'ExportTemplate::list');
$routes->add('exportTemplateChange', 'ExportTemplate::change');
$routes->post('exportTemplateWrite', 'ExportTemplate::write');
$routes->post('exportTemplateDelete', 'ExportTemplate::delete');
$routes->add('exportTemplateImport', 'ExportTemplate::import');
$routes->add('lotList', 'Lot::list');
$routes->add('lotCreate', 'Lot::create');
$routes->add('lotDisplay', 'Lot::display');
$routes->post('lotWrite', 'Lot::write');
$routes->post('lotDelete', 'Lot::delete');
$routes->add('lotDeleteSamples', 'Lot::deleteSamples');
$routes->add('exportChange', 'Export::change');
$routes->post('exportWrite', 'Export::write');
$routes->post('exportDelete', 'Export::delete');
$routes->add('exportExec', 'Export::exec');
$routes->add('requestList', 'Request::list');
$routes->add('requestChange', 'Request::change');
$routes->post('requestWrite', 'Request::write');
$routes->post('requestDelete', 'Request::delete');
$routes->add('requestExec', 'Request::exec');
$routes->add('requestExecList', 'Request::execList');
$routes->post('requestWriteExec', 'Request::write');
$routes->add('requestCopy', 'Request::copy');
$routes->post('apiv1sampleWrite', 'SampleWs::write');
$routes->post('apiv1sampleDelete', 'SampleWs::delete');
$routes->post('apiv1movementWrite', 'MovementWs::write');
$routes->add('apiv1sampleDisplay', 'SampleWs::detail');
$routes->add('apiv1sampleUids', 'SampleWs::getListUIDS');
$routes->add('apiv1sampleList', 'SampleWs::getList');
$routes->add('metadatafield_fr', '\Ppci\Controllers\Markdown::documentation/metadata_field/metadatafield_fr.md');
$routes->add('metadatafield_en', '\Ppci\Controllers\Markdown::documentation/metadata_field/metadatafield_en.md');
$routes->add('lendingsample_fr', '\Ppci\Controllers\Markdown::documentation/lending_sample/lendingsample_fr.md');
$routes->add('lendingsample_en', '\Ppci\Controllers\Markdown::documentation/lending_sample/lendingsample_en.md');
$routes->add('sampledisplay_fr', '\Ppci\Controllers\Markdown::documentation/webservices/sampleDisplayFr.md');
$routes->add('sampledisplay_en', '\Ppci\Controllers\Markdown::documentation/webservices/sampleDisplayEn.md');
$routes->add('documentget_fr', '\Ppci\Controllers\Markdown::documentation/webservices/documentGetFr.md');
$routes->add('documentget_en', '\Ppci\Controllers\Markdown::documentation/webservices/documentGetEn.md');
$routes->add('swidentification_fr', '\Ppci\Controllers\Markdown::documentation/webservices/identificationFr.md');
$routes->add('swidentification_en', '\Ppci\Controllers\Markdown::documentation/webservices/identificationEn.md');
$routes->add('swapi_fr', '\Ppci\Controllers\Markdown::documentation/webservices/apiCallFr.md');
$routes->add('swapi_en', '\Ppci\Controllers\Markdown::documentation/webservices/apiCallEn.md');
$routes->add('sampleWrite_fr', '\Ppci\Controllers\Markdown::documentation/webservices/sampleWriteFr.md');
$routes->add('sampleDelete_fr', '\Ppci\Controllers\Markdown::documentation/webservices/sampleDeleteFr.md');
$routes->add('sampleDelete_en', '\Ppci\Controllers\Markdown::documentation/webservices/sampleDeleteEn.md');
$routes->add('sampleWrite_en', '\Ppci\Controllers\Markdown::documentation/webservices/sampleWriteEn.md');
$routes->add('swmovementWrite_fr', '\Ppci\Controllers\Markdown::documentation/webservices/movementAddFr.md');
$routes->add('swmovementWrite_en', '\Ppci\Controllers\Markdown::documentation/webservices/movementAddEn.md');
$routes->add('swsampleList_fr', '\Ppci\Controllers\Markdown::documentation/webservices/sampleListFr.md');
$routes->add('swsampleList_en', '\Ppci\Controllers\Markdown::documentation/webservices/sampleListEn.md');
$routes->add('exportbatch_fr', '\Ppci\Controllers\Markdown::documentation/import_export/batch_export_fr.md');
$routes->add('exportbatch_en', '\Ppci\Controllers\Markdown::documentation/import_export/batch_export_en.md');
$routes->add('document_external_fr', '\Ppci\Controllers\Markdown::documentation/document_external/document_external_fr.md');
$routes->add('document_external_en', '\Ppci\Controllers\Markdown::documentation/document_external/document_external_en.md');
$routes->add('rights_general_fr', '\Ppci\Controllers\Markdown::documentation/rights/rights_general_fr.md');
$routes->add('rights_general_en', '\Ppci\Controllers\Markdown::documentation/rights/rights_general_en.md');
$routes->add('consult_sees_all_fr', '\Ppci\Controllers\Markdown::documentation/consult_sees_all/consult_sees_all_fr.md');
$routes->add('consult_sees_all_en', '\Ppci\Controllers\Markdown::documentation/consult_sees_all/consult_sees_all_en.md');
$routes->add('automaticsendmail_fr', '\Ppci\Controllers\Markdown::documentation/collection/automaticsendmail_fr.md');
$routes->add('automaticsendmail_en', '\Ppci\Controllers\Markdown::documentation/collection/automaticsendmail_en.md');
$routes->add('mailSmarty', 'MailSmarty::index');
$routes->add('objets', '\Ppci\Controllers\Submenu::index');
$routes->add('movement', '\Ppci\Controllers\Submenu::index');
$routes->add('importExport', '\Ppci\Controllers\Submenu::index');
$routes->add('parametre', '\Ppci\Controllers\Submenu::index');
$routes->add('collections', '\Ppci\Controllers\Submenu::index');
$routes->add('protocoles', '\Ppci\Controllers\Submenu::index');
$routes->add('campaigns', '\Ppci\Controllers\Submenu::index');
$routes->add('containerType', '\Ppci\Controllers\Submenu::index');
$routes->add('dbstructure', '\Ppci\Controllers\Submenu::index');
$routes->add('administration', '\Ppci\Controllers\Submenu::index');
$routes->add('documentation_fr', '\Ppci\Controllers\Submenu::index');
$routes->add('echantillon_fr', '\Ppci\Controllers\Submenu::index');
$routes->add('importExport_fr', '\Ppci\Controllers\Submenu::index');
$routes->add('api_fr', '\Ppci\Controllers\Submenu::index');
$routes->add('administration_fr', '\Ppci\Controllers\Submenu::index');
$routes->add('documentation_en', '\Ppci\Controllers\Submenu::index');
$routes->add('echantillon_en', '\Ppci\Controllers\Submenu::index');
$routes->add('importExport_en', '\Ppci\Controllers\Submenu::index');
$routes->add('api_en', '\Ppci\Controllers\Submenu::index');
$routes->add('administration_en', '\Ppci\Controllers\Submenu::index');
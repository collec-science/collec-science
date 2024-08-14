<?php
namespace Ppci\Config;
use CodeIgniter\Config\BaseConfig;
class OsmMap extends BaseConfig {
    /**
     * Default values for feedCacheMap (OSM map cache)
     *
     * @var integer
     */
    public $mapSeedMinZoom = 12;
    public $mapSeedMaxZoom = 16;
    public $mapSeedMaxAge = 7;
    public $mapCacheMaxAge = 7 * 24 * 3600 * 1000;
}
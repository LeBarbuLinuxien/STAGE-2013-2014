from fabric.api import *
from fabric.context_managers import *
from fabric.contrib import *

env.shell = "/bin/sh -c"

env.roledefs = {
    'all' : ['ademe', 'ag2r', 'aki', 'constellium', 'cbp_espagne', 'cfa_stephenson' ,'cfpc', 'cofidis', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'dmvp', 'dunod', 'ecmg_edoceo', 'ecmg_edoceo_new', 'expanscience', 'frr', 'has', 'kaptitude', 'laser_cofinoga', 'mango_conseil', 'monoprix', 'ort', 'phr_groupexpression', 'poweo', 'record_bank', 'rexel', 'roche', 'spf_grippe', 'stanhome', 'yves_rocher', 'pluton', 'ifis', 'ems', 'generation5_cfa', 'neptune', 'titan', 'uranus', 'jupiter', 'elw_mutualise', 'afpa', 'venus', 'galatee', 'triton', 'nouvelles_frontieres'],
    'elmg52x' : ['ademe', 'ag2r', 'aki', 'constellium', 'cbp_espagne', 'cfa_stephenson' ,'cfpc', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'dmvp', 'expanscience', 'frr', 'has', 'kaptitude', 'laser_cofinoga', 'mango_conseil', 'monoprix', 'ort', 'phr_groupexpression', 'poweo', 'record_bank', 'rexel', 'spf_grippe', 'stanhome', 'yves_rocher', 'pluton', 'ifis', 'generation5_cfa', 'neptune', 'titan', 'uranus', 'afpa', 'venus', 'galatee', 'triton', 'nouvelles_frontieres'],
    'reste' : ['generation5_cfa'],
    'aPatcherElmgDedie52x_dirElmgWww' : ['ademe', 'ag2r', 'aki', 'cfa_stephenson', 'cfpc', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'constellium', 'dmvp', 'expanscience', 'frr', 'has', 'kaptitude', 'laser_cofinoga', 'mango_conseil', 'ort', 'poweo', 'rexel', 'stanhome', 'yves_rocher', 'ifis'],
    'elmg440' : ['roche', 'cofidis'],
    'elmg519' : ['dunod'],
    'mutualized' : ['neptune', 'titan', 'uranus', 'jupiter', 'elw_mutualise', 'galatee', 'triton'],
    'dedicated' : ['ademe', 'ag2r', 'aki', 'constellium', 'cbp_espagne', 'cfa_stephenson' ,'cfpc', 'cofidis', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'dmvp', 'dunod', 'ecmg_edoceo', 'ecmg_edoceo_new', 'expanscience', 'frr', 'has', 'kaptitude', 'laser_cofinoga', 'mango_conseil', 'monoprix', 'ort', 'phr_groupexpression', 'poweo', 'record_bank', 'rexel', 'roche', 'spf_grippe', 'stanhome', 'yves_rocher', 'pluton', 'ifis', 'ems', 'generation5_cfa', 'afpa', 'nouvelles_frontieres'],
    'ubuntu_12.04' : ['ecmg_edoceo_new', 'afpa', 'galatee', 'triton'],
    'ubuntu_10.04' : ['frr', 'monoprix', 'pluton', 'ag2r', 'zabbix', 'venus', 'uranus', 'dmvp', 'record_bank', 'titan', 'jupiter', 'neptune', 'stanhome', 'spf_grippe', 'roche', 'rexel'],
    'ubuntu_8.04' : ['ademe', 'constellium', 'cbp_espagne', 'cfpc', 'cofidis', 'cogedis_ago', 'corporate_fiction', 'cpm', 'crefidis_cofidis', 'dunod', 'ems', 'expanscience', 'generation5_cfa', 'ifis', 'kaptitude', 'laser_cofinoga', 'nouvelles_frontieres', 'ort', 'poweo', 'elw_mutualise', 'ecmg_edoceo'],
    'redhat_5' : ['sauvegarde'],
    'https' : ['uranus', 'aki', 'constellium', 'record_bank', 'monoprix', 'corporate_fiction', 'frr'],
    'http' : ['ademe', 'ag2r', 'cbp_espagne', 'cfa_stephenson' ,'cfpc', 'cofidis', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'dmvp', 'dunod', 'ecmg_edoceo', 'ecmg_edoceo_new', 'expanscience', 'frr', 'has', 'kaptitude', 'mango_conseil', 'monoprix', 'nouvelles_frontieres', 'ort', 'phr_groupexpression', 'poweo', 'rexel', 'roche', 'spf_grippe', 'stanhome', 'yves_rocher', 'pluton', 'ems', 'generation5_cfa', 'ifis', 'laser_cofinoga', 'afpa', 'galatee', 'triton', 'nouvelles_frontieres'],
    'ftpes' : ['uranus', 'aki', 'laser_cofinoga', 'record_bank'],
    'ftp' : ['ademe', 'ag2r', 'cbp_espagne', 'cfa_stephenson' ,'cfpc', 'cofidis', 'cogedis_ago', 'corporate_fiction','cpm', 'crefidis_cofidis', 'dmvp', 'dunod', 'ecmg_edoceo', 'ecmg_edoceo_new', 'expanscience', 'frr', 'has', 'kaptitude', 'mango_conseil', 'monoprix', 'nouvelles_frontieres', 'ort', 'phr_groupexpression', 'poweo', 'rexel', 'roche', 'spf_grippe', 'stanhome', 'yves_rocher', 'pluton', 'ems', 'generation5_cfa', 'ifis'],
    'ecmg' : ['jupiter', 'ecmg_edoceo', 'ecmg_edoceo_new', 'elw_mutualise', 'triton'],
    'ems' : ['ems'],
    'elmg_440' : ['cofidis'],
    'club' : ['pluton'],
    'zabbix' : ['zabbix'],
    'managerELMG' : ['neptune', 'titan', 'generation5_cfa', 'galatee', 'triton'],
    'managerECMG' : ['jupiter', 'triton'],
    'managerETS' : ['titan']
}

def deploiement_Rsyslog():
    run("sudo mkdir -p /etc/ssl/pki/")
    run('chmod 700 /etc/ssl/pki/')
    put('/etc/ssl/pki/ca.pem', '/etc/ssl/pki/ca.pem')
    put('/home/utils/serveurs/deploiement_rsyslog.sh', '/root/serveurs/deploiement_rsyslog.sh', mode=700)
    run('/root/serveurs/deploiement_rsyslog.sh')
    run('rm -rf /root/serveurs/')



## Manuell im Browser

```
https://eu-central-1.console.aws.amazon.com/rds/home?region=eu-central-1
```

```
Launch a DB Instance
```

```
Backup Retention Period: 0
```

```
java -jar ~/Apps/ili2pg-3.9.1/ili2pg.jar --dbhost XXXXXXXXXXXXXXX --dbport 5432 --dbusr stefan --dbpwd YYYYYYY --dbdatabase xanadu2 --setupPgExt --nameByTopic --createEnumTabs --strokeArcs --createFk --createFkIdx --createUnique --createNumChecks --models SO_ARP_Nutzungsvereinbarung_20170512 --dbschema arp_nutzungsvereinbarung --import nutzungsvereinbarung_20170529.xtf
```

Hello future NRCAuthAdmin developer:

So, NRCAuthAdmin is used by the Reveal/Catalyst Advanced Dashboard software (http://nrcwiki.nationalresearch.com/mediawiki/index.php/Reveal),
which exclusively uses the accounts configured in the NRCAuth Production environment for a variety of reasons.  So, unfortunately we're unable
to use the QP_Params database to store our connection strings for the CatalystStar database.  Instead of having separate copies of the app.config,
I'd like to create individual build targets and specify app.config key changes for each target, but that's a task for another day.

Additionally, I've recreated the TemporaryKey.pfx which was referenced in the project but not actually checked in.  Password is "abc123".

--Alex Gallichotte (agallichotte@nationalresearch.com) 1/7/14
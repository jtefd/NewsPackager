package NewsPackager::DB;

use NewsPackager::DB::Schema;

my $schema;

my $connect_info = {
	dbname => 'newspkg',
	username => 'newspkg',
	password => 'newspkg'
};

sub schema {
	unless (defined($schema)) {
		$schema = NewsPackager::DB::Schema->connect('dbi:Pg:dbname=' . $connect_info->{'dbname'}, $connect_info->{'username'}, $connect_info->{'password'});
	}
	
	return $schema;
}

1;


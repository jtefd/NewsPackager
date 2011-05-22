package NewsPackager::DB;

use NewsPackager::DB::Schema;

use vars qw/$__schema $__connect_info/;

$__connect_info = {
	dbname => 'newspkg',
	username => 'newspkg',
	password => 'newspkg'
};

sub schema() {
	unless (defined($schema)) {
		$__schema = NewsPackager::DB::Schema->connect(
			sprintf('dbi:Pg:dbname=%s', $__connect_info->{'dbname'}),
			$__connect_info->{'username'}, 
			$__connect_info->{'password'});
	}
	
	return $__schema;
}

1;
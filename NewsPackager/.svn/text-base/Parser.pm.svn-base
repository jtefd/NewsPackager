package NewsPackager::Parser;

use Moose::Role;

requires 'getContent';
requires 'listFeeds';

use LWP::UserAgent;

has 'user_agent' => (
	is => 'ro',
	isa => 'LWP::UserAgent',
	default => sub {
		return LWP::UserAgent->new();
	}
);

1;
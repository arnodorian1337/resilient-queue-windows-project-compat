from dataclasses import dataclass


@dataclass
class Job:
    payload: str
    attempts: int = 0


def should_retry(job: Job, limit: int = 3) -> bool:
    """Return whether a failed job may be retried."""
    return job.attempts < limit
